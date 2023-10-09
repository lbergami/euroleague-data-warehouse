with 

game_factors_rs_23 as (
   
   select *
   from {{ ref('fct_game_factors') }} 
   where season = 2023 

)

select *
from game_factors_rs_23