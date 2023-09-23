with 

source_table as (

    select
        season, 
        game_id, 
        team_code as home_team_code, 
        shot_zone_label, 
        shooting_selection_pct, 
        shooting_pct, 
        case 
            when team_code = 'pan' then 'Panathinaikos Athens'
            when team_code = 'asv' then 'Ldlc Asvel Villeurbanne'
            when team_code = 'tel' then 'Maccabi Playtika Tel Aviv'
            when team_code = 'mun' then 'Fc Bayern Munich'
        end as home_team 
    from {{ ref('fct_shooting_pct') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4) and flag_home_team = 1  
) 

select *
from source_table 
