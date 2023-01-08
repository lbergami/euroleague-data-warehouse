# Description: Extract Euroleague Plya-by-Play data (2007-2022) ---------------

# Import libraries
import pandas as pd
import requests
import awswrangler as wr

# Import list of seasons and game Ids
import init_euroleague_season_list
lkpSeasons = init_euroleague_season_list.lkpSeasons


# Set out the extraction function for box score data 
def extract_box_scores(lkpSeason_arg):
    
    # Create empty lists for output
    list_box_scores = []
    list_not_valid_game_id = []
    list_failed_requests = []
    
    for game_id, year_id, season_label in zip(list(lkpSeason_arg.game_id), list(lkpSeason_arg.year_id), list(lkpSeason_arg.season_id)):
        
        # Assign the url and make the request to the web page
        url = "https://live.euroleague.net/api/Boxscore?gamecode=" + str(game_id) + "&seasoncode=E" + year_id
        url_request = requests.get(url)
        
        # Extract observations for each period of the game 
        if url_request.status_code == 200:
        
           try:
               
               # Data in jason format 
               box_score_list = url_request.json()
               
               # Extract box score for each game 
               
               # Box score for Home team 
               dfHome = pd.DataFrame(box_score_list['Stats'][0]['PlayersStats'])
               dfHome['FlagHomeTeam'] = True
                              
               # Box score for Away team 
               dfAway = pd.DataFrame(box_score_list['Stats'][1]['PlayersStats'])
               dfAway['FlagHomeTeam'] = False
               
               # Combine in one table 
               dfBoxScore = pd.concat([dfHome, dfAway])
               
               # Further cleanings
               
               # Add IDs variables 
               dfBoxScore['GAME_ID'] = game_id
               dfBoxScore['SEASON'] = season_label
               
               # Reset the index 
               dfBoxScore.reset_index(drop = True, inplace = True)
               
               # Drop varibales that are not relevant (if present)
               if 'IsPlaying' in list(dfBoxScore.columns):
                   dfBoxScore.drop(columns = ['IsPlaying'], inplace = True)

               # Save the dataframe in the list 
               list_box_scores.append(dfBoxScore)
           
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
    
       
    return list_box_scores, list_not_valid_game_id, list_failed_requests
 
# Call the func and extract the dataset with pbp 
list_box_scores_games =  extract_box_scores(lkpSeason_arg = lkpSeasons)

# Create the dataset with box scores data 
dfBoxScores =  pd.concat(list_box_scores_games[0])

# Export to S3 
wr.s3.to_parquet(
    df = dfBoxScores,
    path = "s3://project-drazen/box-score-data/", 
    dataset = True, 
    filename_prefix = 'dfBoxScores_')

# Create the dataset with box scores data with non-valid game_id 
dfBoxScoresNoValidGameId =  pd.concat(list_box_scores_games[1])

# Export to S3 
wr.s3.to_parquet(
    df = dfBoxScoresNoValidGameId,
    path = "s3://project-drazen/box-score-data/", 
    dataset = True, 
    filename_prefix = 'dfBoxScoresNoValidGameId_')

                            



