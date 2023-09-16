with 

source_table as (

    select *
    from {{ ref('fct_shooting_pct') }}
    where season = '2022-23' and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4)

) 
select * 
from source_table
where flag_team_home = 0