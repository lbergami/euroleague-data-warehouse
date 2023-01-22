# Description: Extract data from 2007 to 2022 ---------------------------------

# Notes:
# - For the current season (22/23) we only have the first 35 games

# 0. Prep work ----------------------------------------------------------------

# 0.1 Import libraries
import pandas as pd
#import numpy as np
#import requests
import awswrangler as wr

# 0.2 Import functions / IDs games 
from extract_functions  import extract_pbp_f, extract_box_scores_f, extract_shots_f

# Import list of seasons and game Ids
import init_euroleague_season_list
lkpSeasons = init_euroleague_season_list.lkpSeasons


# 1. Play-by-play data --------------------------------------------------------

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


# 2. Box-score data ----------------------------------------------------------- 

# Call the func and extract the dataset with pbp 
list_box_scores_games =  extract_box_scores_f(lkpSeason_arg = lkpSeasons)

# Create the dataset with box scores data 
dfBoxScores =  pd.concat(list_box_scores_games[0])

# Export to S3 
wr.s3.to_parquet(
    df = dfBoxScores,
    path = "s3://project-drazen/box-score-data/", 
    dataset = True, 
    filename_prefix = 'dfBoxScores_')

# 3. Shot data ----------------------------------------------------------- 

# Call the func and extract the dataset with pbp 
list_shots_games =  extract_shots_f(lkpSeason_arg = lkpSeasons)

# Create the dataset with play-by-play data 
dfShots =  pd.concat(list_shots_games[0])

# Export to S3 
wr.s3.to_parquet(
    df = dfShots,
    path = "s3://project-drazen/shots-data/", 
    dataset = True, 
    filename_prefix = 'dfShots_')


