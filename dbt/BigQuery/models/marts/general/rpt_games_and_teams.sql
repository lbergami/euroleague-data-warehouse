with 

games_and_teams as (
   
   select *
   from {{ ref('dim_games_and_teams') }} 
   where season > 2022

)

select *
from games_and_teams