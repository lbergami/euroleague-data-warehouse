# Description: Extract data for 2024 season -----------------------------------
# The script allows data scraping as the season progresses

# 0. Prep work ----------------------------------------------------------------

# Import libraries
import pandas as pd

# Set Google Storage client key
path_to_private_key = PRIVATE_KEY

# Import functions to extract the data 
from extract_functions  import extract_pbp_f, extract_box_scores_f, extract_shots_f

# Import lookups with game Ids 

dfIds = pd.read_csv('gs://project-drazen-bucket/general-bucket/dfIds_season_24.csv',
                    storage_options = {"token": path_to_private_key})

lkpRawSeason24 = pd.read_csv(PATH_TO_BUCKET,
                             storage_options = {"token": path_to_private_key})

# Get batch numeric ID 
batch_num_id = list(lkpRawSeason24.batch.unique())[0]


# 1. Play-by-play data --------------------------------------------------------

# Extract pbp data 
list_pbp_games =  extract_pbp_f(lkpSeason_arg = lkpRawSeason24)

# Combine the pbp data in one dataframe  
dfPlayByPlay =  pd.concat(list_pbp_games[0], ignore_index = True)

# Create a numeric id
dfPlayByPlay["PLAY_BY_PLAY_ID"] = dfPlayByPlay.index + 1 + dfIds["PLAY_BY_PLAY_ID"].iloc[0]

# Export pbp data in the google storage bucket 
pbp_destination_path = PATH_TO_BUCKET
dfPlayByPlay.to_csv(pbp_destination_path,
                    storage_options = {"token": path_to_private_key}, 
                    index = False)


# 2. Box-score data ----------------------------------------------------------- 

# Extract box scores data
list_box_scores_games =  extract_box_scores_f(lkpSeason_arg = lkpRawSeason24)

# Combine data in one dataframe 
dfBoxScores =  pd.concat(list_box_scores_games[0], ignore_index = True)

# Create a numeric id for the dataset
dfBoxScores["BOX_SCORES_ID"] = dfBoxScores.index + 1 + dfIds["BOX_SCORES_ID"].iloc[0] 

# Export the box scores data in the google storage bucket 
box_scores_destination_path = PATH_TO_BUCKET
dfBoxScores.to_csv(box_scores_destination_path,
                   storage_options = {"token": path_to_private_key}, 
                   index = False)


# 3. Shot data ---------------------------------------------------------------- 

# Extract shots data 
list_shots_games =  extract_shots_f(lkpSeason_arg = lkpRawSeason24)

# Create the dataset with play-by-play data 
dfShots =  pd.concat(list_shots_games[0], ignore_index = True)

# Create a numeric id for the dataset
dfShots["SHOT_ID"] = dfShots.index + 1 + dfIds["SHOT_ID"].iloc[0]

# Export shots data in the google storage bucket 
shots_destination_path = PATH_TO_BUCKET
dfShots.to_csv(shots_destination_path,
               storage_options = {"token": path_to_private_key}, 
               index = False)


# 4. Amend dfIds for future data extraction -----------------------------------

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

dfIds.to_csv(PATH_TO_BUCKET,
             storage_options = {"token": path_to_private_key}, 
             index = False)


# 5. Amend Season 24 lookup for future data extraction ------------------------

# Get last game_id extracted 
last_game_id = list(dfIds.GAME_ID.unique())[0]

# Amend the Season 24 lookup and export for next extraction 
lkpRawSeason24 = lkpRawSeason24[lkpRawSeason24['game_id'] > last_game_id]
lkpRawSeason24['batch'] = batch_num_id + 1

# Export 
lkpRawSeason24.to_csv(PATH_TO_BUCKET,
             storage_options = {"token": path_to_private_key}, 
             index = False)