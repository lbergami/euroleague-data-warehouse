with 

source_table as (

    select *
    from {{ ref('int_shot_locations') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4)

) 
select 
    season, 
    game_id, 
    team_code, 
    coord_x, 
    coord_y, 
    made_shot, 
    case 
        when team_code = 'pan' then 'Panathinaikos Athens'
        when team_code = 'asv' then 'Ldlc Asvel Villeurbanne'
        when team_code = 'tel' then 'Maccabi Playtika Tel Aviv'
        when team_code = 'mun' then 'Fc Bayern Munich'
    end as home_team_code 
from source_table
where team_code = 'pan' or team_code = 'asv' or team_code = 'tel' or team_code = 'mun' 