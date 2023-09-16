with 

source_table as (

    select *
    from {{ ref('int_shot_locations') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4)

) 
select * 
from source_table
where team = 'mad' or team = 'mil' or team = 'zal' or team = 'ulk'