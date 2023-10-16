with 

game_factors_sample as (
   
   select *
   from {{ ref('fct_game_factors') }} 
   where season > 2022 and game_id < 19

)

select *
from game_factors_sample