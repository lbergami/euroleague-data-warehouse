with

home_away_teams as (

    select
        season,
        game_id,
        home_team,
        home_team_code,
        away_team,
        away_team_code
    from {{ ref('dim_games_and_teams') }}

),

home_shot_pct as (

    select
        hsp.season,
        hsp.game_id,
        hat.home_team,
        hsp.team_code as home_team_code,
        hat.away_team,
        hat.away_team_code,
        hsp.shot_zone_label,
        hsp.shooting_selection_pct,
        hsp.shooting_pct,
        hsp.shot_zone_ordered_num_label,
        hsp.flag_home_team
    from {{ ref('fct_shooting_pct') }} as hsp
    left join home_away_teams as hat
        on
            hsp.season = hat.season
            and hsp.game_id = hat.game_id
            and hsp.team_code = hat.home_team_code
    where hsp.season > 2022 and hsp.flag_home_team = 1

), 

away_shot_pct as (

    select
        asp.season,
        asp.game_id,
        hat.home_team,
        asp.team_code as away_team_code,
        hat.away_team,
        hat.away_team_code,
        asp.shot_zone_label,
        asp.shooting_selection_pct,
        asp.shooting_pct,
        asp.shot_zone_ordered_num_label,
        asp.flag_home_team
    from {{ ref('fct_shooting_pct') }} as asp
    left join home_away_teams as hat
        on
            asp.season = hat.season
            and asp.game_id = hat.game_id
            and asp.team_code = hat.away_team_code
    where asp.season > 2022 and asp.flag_home_team = 0

)

select *
from home_shot_pct
union all
select *
from away_shot_pct
