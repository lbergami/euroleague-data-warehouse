with 

source_table as (

    select
        season, 
        game_id, 
        team as home_team_code, 
        shot_zone_label, 
        shooting_selection_pct, 
        shooting_pct, 
        case 
            when team = 'pan' then 'Panathinaikos Athens'
            when team = 'asv' then 'Ldlc Asvel Villeurbanne'
            when team = 'tel' then 'Maccabi Playtika Tel Aviv'
            when team = 'mun' then 'Fc Bayern Munich'
        end as home_team 
    from {{ ref('fct_shooting_pct') }}
    where season = 2022 and (game_id = 1 or game_id = 2 or game_id = 3 or game_id = 4) and flag_team_home = 1  
) 

select *
from source_table 
