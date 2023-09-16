
with 

source_table as (

    select *
    from {{ ref('fct_game_factors') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4)

) 
select * 
from source_table