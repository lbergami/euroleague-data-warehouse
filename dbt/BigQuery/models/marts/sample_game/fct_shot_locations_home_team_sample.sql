with 

source_table as (

    select *
    from {{ ref('int_shot_locations') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4)

) 
select 
    season, 
    game_id, 
    team, 
    coord_x, 
    coord_y, 
    made_shot, 
    case 
        when team = 'pan' then 'Panathinaikos Athens'
        when team = 'asv' then 'Ldlc Asvel Villeurbanne'
        when team = 'tel' then 'Maccabi Playtika Tel Aviv'
        when team = 'mun' then 'Fc Bayern Munich'
    end as home_team 
from source_table
where team = 'pan' or team = 'asv' or team = 'tel' or team = 'mun' 