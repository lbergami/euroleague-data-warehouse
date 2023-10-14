with 

game_factors as (
   
   select *
   from {{ ref('fct_game_factors') }} 
   where season > 2022 

)

select *
from game_factors