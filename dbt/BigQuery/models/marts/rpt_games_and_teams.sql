with 

games_and_teams_rs_23 as (
   
   select *
   from {{ ref('dim_games_and_teams') }} 
   where season = 2023 

)

select *
from games_and_teams_rs_23