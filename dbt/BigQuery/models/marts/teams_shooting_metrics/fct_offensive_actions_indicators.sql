/* Create factor table incl. offensive action indicators (e.g. fastbreak, 2nd chance, etc.) */

with

/* Import dimension table with home/away indicator */
home_away_teams as (

    select *
    from {{ ref('dim_games_home_away_teams') }}

),

offensive_action_indicators as (

    select
        season,
        game_id,
        team_code,
        sum(fastbreak) as fastbreak,
        sum(second_chance) as second_chance,
        sum(points_off_turnover) as points_off_turnover
    from {{ ref('int_shot_locations') }}
    group by 1, 2, 3

)

select
    oai.season,
    oai.game_id,
    oai.team_code,
    oai.fastbreak,
    oai.second_chance,
    oai.points_off_turnover,
    hwt.flag_home_team
from offensive_action_indicators as oai
left join home_away_teams as hwt
    on
        oai.season = hwt.season
        and oai.game_id = hwt.game_id
        and oai.team_code = hwt.team_code
order by season, game_id
