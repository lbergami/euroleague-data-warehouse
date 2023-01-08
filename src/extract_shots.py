# Description: Extract Euroleague Shots data (2007-2022) ----------------------

# Import libraries
import pandas as pd
import requests
import awswrangler as wr

# Import list of seasons and game Ids
import init_euroleague_season_list
lkpSeasons = init_euroleague_season_list.lkpSeasons


# Set out the extraction function for shots data 
def extract_shots(lkpSeason_arg):
    
    # Create empty lists for output
    list_shots = []
    list_not_valid_game_id = []
    list_failed_requests = []
    
    for game_id, year_id, season_label in zip(list(lkpSeason_arg.game_id), list(lkpSeason_arg.year_id), list(lkpSeason_arg.season_id)):
        
        # Assign the url and make the request to the web page
        url = "https://live.euroleague.net/api/Points?gamecode=" + str(game_id) + "&seasoncode=E" + year_id
        url_request = requests.get(url)
        
        # Extract observations for each period of the game 
        if url_request.status_code == 200:
        
           try:
               
               # Data in jason format 
               shot_dict = url_request.json()
               dfShots = pd.DataFrame.from_dict(shot_dict['Rows'])
               
               # Further cleanings
               
               # Add IDs variables 
               dfShots['GAME_ID'] = game_id
               dfShots['SEASON'] = season_label
               
               # Drop varibales that are not relevant (if present)
               if 'UTC' in list(dfShots.columns):
                   dfShots.drop(columns = ['UTC'], inplace = True)

               # Rename team points variables   
               if 'POINTS_A' in list(dfShots.columns):
                   dfShots.rename(columns = {'POINTS_A': 'POINTS_HOME'}, inplace = True)
               
               if 'POINTS_B' in list(dfShots.columns):
                   dfShots.rename(columns = {'POINTS_B': 'POINTS_AWAY'}, inplace = True)
               
               # Save the output
               list_shots.append(dfShots)
           
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
    
       
    return list_shots, list_not_valid_game_id, list_failed_requests
 
# Call the func and extract the dataset with pbp 
list_shots_games =  extract_shots(lkpSeason_arg = lkpSeasons)

# Create the dataset with play-by-play data 
dfShots =  pd.concat(list_shots_games[0])

# Export to S3 
wr.s3.to_parquet(
    df = dfShots,
    path = "s3://project-drazen/shots-data/", 
    dataset = True, 
    filename_prefix = 'dfShots_')

# Create the dataset with play-by-play data with non-valid game_id 
dfShotsNoValidGameId =  pd.concat(list_shots_games[1])

# Export to S3 
wr.s3.to_parquet(
    df = dfShotsNoValidGameId,
    path = "s3://project-drazen/shots-data/", 
    dataset = True, 
    filename_prefix = 'dfShotsNoValidGameId_')

                            



