# Description: Extract Euroleague Play-by-play data (2007-2022)----------------

# Import libraries
import pandas as pd
import numpy as np
import requests
import awswrangler as wr

# Import list of seasons and game Ids
import init_euroleague_season_list
lkpSeasons = init_euroleague_season_list.lkpSeasons


# Set out the extraction function for play-by-play data 
def extract_pbp_f(lkpSeason_arg):
    
    # Create empty lists for output
    list_pbp_games = []
    list_not_valid_game_id = []
    list_failed_requests = []
    
    for game_id, year_id, season_label in zip(list(lkpSeason_arg.game_id), list(lkpSeason_arg.year_id), list(lkpSeason_arg.season_id)):
        
        # Assign the url and make the request to the web page
        url = "https://live.euroleague.net/api/PlaybyPlay?gamecode=" + str(game_id) + "&seasoncode=E" + year_id
        url_request = requests.get(url)
        
        # Extract observations for each period of the game 
        if url_request.status_code == 200:
        
           try:
               
               # Data in jason format 
               pbp_game = url_request.json()

               # Check if game ended in extra time 
               if len(pbp_game['ExtraTime']) > 0:
                   game_period = ['FirstQuarter', 'SecondQuarter', 'ThirdQuarter', 'ForthQuarter', 'ExtraTime']
               else:     
                   game_period = ['FirstQuarter', 'SecondQuarter', 'ThirdQuarter', 'ForthQuarter']
               
               # Create a dataframe with play-by-play observation 
               list_pbp_game = []
               for p in game_period:
                   # Extract period of the game from the disctionary and convert it as df 
                   dfTmp = pd.DataFrame.from_dict(pbp_game[p])
                   
                   # Add IDs variables 
                   dfTmp['GAME_PERIOD'] = p
                   dfTmp['GAME_ID'] = game_id
                   dfTmp['SEASON'] = season_label
                   
                   # Drop variables that are not relevant (if present) 
                   if 'TYPE' in list(dfTmp.columns):
                       dfTmp.drop(columns = ['TYPE'], inplace = True)
                       
                   if 'NUMBEROFPLAY' in list(dfTmp.columns):
                       dfTmp.drop(columns = ['NUMBEROFPLAY'], inplace = True)
                       
                   if 'COMMENT' in list(dfTmp.columns):
                       dfTmp.drop(columns = ['COMMENT'], inplace = True)

                   # Rename scoring 
                   if 'POINTS_A' in list(dfTmp.columns):
                       dfTmp.rename(columns = {'POINTS_A': 'POINTS_HOME'}, inplace = True)    
                    
                   if 'POINTS_B' in list(dfTmp.columns):
                       dfTmp.rename(columns = {'POINTS_B': 'POINTS_AWAY'}, inplace = True)      
                   
                   # Save the output 
                   list_pbp_game.append(dfTmp)   
                   
               # Combine period play-by-play data in one dataframe
               dfTmpGame =  pd.concat(list_pbp_game)
               
               # Clean home/away points 
               dfTmpGame.reset_index(drop = True, inplace = True)
               dfTmpGame.loc[0, 'POINTS_HOME'] = 0
               dfTmpGame.loc[0, 'POINTS_AWAY'] = 0
               dfTmpGame.POINTS_HOME.fillna(method = 'ffill', inplace = True) 
               dfTmpGame.POINTS_AWAY.fillna(method = 'ffill', inplace = True)
               
               # Create Shot clock variable
               
               # Add remaining minutes at the start / end of the game 
               dfTmpGame.loc[dfTmpGame['PLAYTYPE'] == 'BP', 'MARKERTIME'] = '10:00'
               dfTmpGame.loc[dfTmpGame['PLAYTYPE'] == 'EP', 'MARKERTIME'] = '00:00'
               dfTmpGame.loc[dfTmpGame['PLAYTYPE'] == 'EG', 'MARKERTIME'] = '00:00'
               
               # Create a MARKERTIME version in seconds 
               dfTmpGame['MARKERTIME_SECONDS'] = (pd.to_numeric(dfTmpGame['MARKERTIME'].str.split(':').str[0])) * 60 \
                                               + pd.to_numeric(dfTmpGame['MARKERTIME'].str.split(':').str[1])

        
               # Select relevant variables for shot clock calculations
               dfTmpGame['GAME_PLAY_ID'] = dfTmpGame.reset_index().index
               dfTmpGame['PLAYTYPE'] = dfTmpGame['PLAYTYPE'].str.replace(" ", "")
               lkpShotClock = dfTmpGame[['MARKERTIME', 'MARKERTIME_SECONDS', 'GAME_PLAY_ID', 'TEAM', 'PLAYTYPE', 'PLAYINFO']] 

               # Drop play types that are not relevant for the shot clock calculation
               remove_list = ['CM', 'FTA', 'FTM', 'OF', 'OUT', 'IN', 'AS', 'TOUT', 'FV', 'TOUT_TV']
               lkpShotClock = lkpShotClock[~lkpShotClock['PLAYTYPE'].isin(remove_list)]
                   
               # Create additional temporary variables 
               lkpShotClock['LAG_MARKERTIME_SECONDS'] = lkpShotClock['MARKERTIME_SECONDS'].shift()
               lkpShotClock['LAG_TEAM'] = lkpShotClock['TEAM'].shift()
               lkpShotClock['LAG_PLAYTYPE'] = lkpShotClock['PLAYTYPE'].shift()
               lkpShotClock['SHOT_CLOCK'] = np.nan
               
               # Create shotclock variables 
               for game_play_id in list(lkpShotClock.GAME_PLAY_ID.unique()):
                   
                   # Create additional specific to game plays  
                   play_type = lkpShotClock.loc[game_play_id, 'PLAYTYPE']
                   lag_play_type = lkpShotClock.loc[game_play_id, 'LAG_PLAYTYPE']
                   
                   same_ball_possession = lkpShotClock.loc[game_play_id, 'TEAM'] == lkpShotClock.loc[game_play_id, 'LAG_TEAM'] 
                   
                   diff_shot_clock_previous_play =   lkpShotClock.loc[game_play_id, 'LAG_MARKERTIME_SECONDS'] - lkpShotClock.loc[game_play_id, 'MARKERTIME_SECONDS']
                   
                   lkpShotClock['LAG_SHOT_CLOCK'] = lkpShotClock['SHOT_CLOCK'].shift() 
                   lag_shot_clock = lkpShotClock.loc[game_play_id, 'LAG_SHOT_CLOCK']
                   game_clock = lkpShotClock.loc[game_play_id, 'MARKERTIME_SECONDS']
                   
                   # Set game clock = shot clock for last 24 second of each period
                   if game_clock <= 24:
                       lkpShotClock.loc[game_play_id, 'SHOT_CLOCK'] = game_clock
                   
                   # Begin Period / Tip-off/ End game - clock shot set to 24
                   # as well as defensive rebound and steals 
                   elif (play_type in ['BP', 'JB', 'EP', 'EG', 'ST']) or (play_type == 'D'): 
                       lkpShotClock.loc[game_play_id, 'SHOT_CLOCK'] = 24
                   
                   # Change in ball possession 
                   elif same_ball_possession == False: 
                       lkpShotClock.loc[game_play_id, 'SHOT_CLOCK'] = 24 - diff_shot_clock_previous_play 
                   
                   # Same ball possession  
                   else:   
                       
                       if (lag_play_type in['O', 'RV'] and lag_shot_clock < 14):
                          lkpShotClock.loc[game_play_id, 'SHOT_CLOCK'] = 14 -  diff_shot_clock_previous_play
                            
                       else: 
                          lkpShotClock.loc[game_play_id, 'SHOT_CLOCK'] = lag_shot_clock - diff_shot_clock_previous_play
                           
               # Select shot clock variables 
               lkpShotClock = lkpShotClock[['GAME_PLAY_ID', 'SHOT_CLOCK']]
               
               # Replace shot clock values with negatives values 
               lkpShotClock.loc[lkpShotClock['SHOT_CLOCK'] < 0, 'SHOT_CLOCK'] = 1
               
               # Join the lookup with main data 
               dfTmpGame = dfTmpGame.merge(lkpShotClock, on = 'GAME_PLAY_ID', how = 'left')
               dfTmpGame.SHOT_CLOCK.fillna(method = 'ffill', inplace = True)
               
               # Save the game play-by-play in the output 
               list_pbp_games.append(dfTmpGame)
           
           except:
             # If the request does not return a json request, game_id is assumed not to be associated to any real game 
             # Save the game_id / year_id
             list_not_valid_game_id.append(
                 pd.DataFrame(
                     dict(game_id = game_id, 
                          year_id =  year_id, 
                          season_label = season_label), 
                     index = [0]
                     )
                 )
        # Save the game_id / year_id if get request failed      
        else:
          list_failed_requests.append(
              pd.DataFrame(
                  dict(game_id = game_id, 
                       year_id =  year_id, 
                       season_label = season_label), 
                  index = [0]
                  )
              )
    
       
    return list_pbp_games, list_not_valid_game_id, list_failed_requests
 
# Call the func and extract the dataset with pbp 
list_pbp_games =  extract_pbp_f(lkpSeason_arg = lkpSeasons)

# Create the dataset with play-by-play data 
dfPlayByPlay =  pd.concat(list_pbp_games[0])

# Export to S3 
wr.s3.to_parquet(
    df = dfPlayByPlay,
    path = "s3://project-drazen/play-by-play-data/", 
    dataset = True, 
    filename_prefix = 'dfPlayByPlay_')

# Create the dataset with play-by-play data with non-valid game_id 
dfPlayByPlayNoValidGameId =  pd.concat(list_pbp_games[1])

# Export to S3 
wr.s3.to_parquet(
    df = dfPlayByPlayNoValidGameId,
    path = "s3://project-drazen/play-by-play-data/", 
    dataset = True, 
    filename_prefix = 'dfPlayByPlayNoValidGameId_')

                            



