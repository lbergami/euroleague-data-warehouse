with 

games_sample as (
   
   select *
   from {{ ref('rpt_shooting_pct') }} 
   where season > 2022 and game_id < 19

)

select *
from games_sample