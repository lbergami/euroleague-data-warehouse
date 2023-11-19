# Description: Extract data for 2008 to 2022 seasons -------------------------

# 0. Prep work ----------------------------------------------------------------

# Import libraries
import pandas as pd
from google.cloud import storage

# Set Google Storage client key
path_to_private_key = PRIVATE_KEY
client = storage.Client.from_service_account_json(json_credentials_path=path_to_private_key)
bucket = client.bucket(PATH_TO_BUCKET)

# Import functions to extract the data 
from extract_functions  import extract_pbp_f, extract_box_scores_f, extract_shots_f

# Import list of seasons and game Ids
import init_euroleague_season_list
lkpSeasons = init_euroleague_season_list.lkpSeasons

# 1. Play-by-play data --------------------------------------------------------

# Extract pbp data 
list_pbp_games =  extract_pbp_f(lkpSeason_arg = lkpSeasons)

# Combine the pbp data in one dataframe  
dfPlayByPlay =  pd.concat(list_pbp_games[0], ignore_index = True)

# Create a numeric id
dfPlayByPlay["PLAY_BY_PLAY_ID"] = dfPlayByPlay.index + 1

# Export pbp data in the google storage bucket 
blob = bucket.blob(PATH_TO_BUCKET + '/dfPlayByPlay.csv')
blob.upload_from_string(dfPlayByPlay.to_csv(index = False), 'text/csv', timeout = 900)


# 2. Box-score data ----------------------------------------------------------- 

# Extract box scores data
list_box_scores_games =  extract_box_scores_f(lkpSeason_arg = lkpSeasons)

# Combine data in one dataframe 
dfBoxScores =  pd.concat(list_box_scores_games[0], ignore_index = True)

# Create a numeric id for the dataset
dfBoxScores["BOX_SCORES_ID"] = dfBoxScores.index + 1

# Export the box scores data in the google storage bucket 
blob = bucket.blob(PATH_TO_BUCKET + '/dfBoxScores.csv')
blob.upload_from_string(dfBoxScores.to_csv(index = False), 'text/csv', timeout = 900)


# 3. Shot data ---------------------------------------------------------------- 

# Extract shots data 
list_shots_games =  extract_shots_f(lkpSeason_arg = lkpSeasons)

# Create the dataset with play-by-play data 
dfShots =  pd.concat(list_shots_games[0], ignore_index = True)

# Create a numeric id for the dataset
dfShots["SHOT_ID"] = dfShots.index + 1

# Export shots data in the google storage bucket 
blob = bucket.blob(PATH_TO_BUCKET + '/dfShots.csv')
blob.upload_from_string(dfShots.to_csv(index = False), 'text/csv', timeout = 900)

# 4. Extract the Max ID from each table for future data extraction ------------

# Get max ID fro each table 
max_pbp_id = dfPlayByPlay['PLAY_BY_PLAY_ID'].max()
max_bs_id = dfBoxScores['BOX_SCORES_ID'].max()
max_shots_id = dfShots['SHOT_ID'].max()

# Select relevant variables from each table 
dfPbPMaxId = dfPlayByPlay[['SEASON', 'GAME_ID', 'PLAY_BY_PLAY_ID']][dfPlayByPlay.PLAY_BY_PLAY_ID == max_pbp_id].reset_index(drop = True)
dfBsMaxId = dfBoxScores[['SEASON', 'GAME_ID', 'BOX_SCORES_ID']][dfBoxScores.BOX_SCORES_ID == max_bs_id].reset_index(drop = True)
dfShotsMaxId = dfShots[['SEASON', 'GAME_ID', 'SHOT_ID']][dfShots.SHOT_ID == max_shots_id].reset_index(drop = True)

# Combine in one table and export 
dfIds = dfPbPMaxId.merge(dfBsMaxId, how = 'left', on = ['SEASON', 'GAME_ID'])
dfIds = dfIds.merge(dfShotsMaxId, how = 'left', on = ['SEASON', 'GAME_ID'])
blob = bucket.blob('dfIds.csv')
blob.upload_from_string(dfIds.to_csv(index = False), 'text/csv')



