with 

games_and_teams_sample as (
   
   select *
   from {{ ref('dim_games_and_teams') }} 
   where season > 2022 and game_id < 19

)

select *
from games_and_teams_sample