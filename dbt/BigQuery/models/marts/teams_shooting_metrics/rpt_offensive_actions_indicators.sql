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

home_offensive_2023 as (

    select
        oai.season,
        oai.game_id,
        hat.home_team,
        oai.team_code as home_team_code,
        oai.fastbreak as home_team_fastbreak,
        oai.second_chance as home_team_second_chance,
        oai.points_off_turnover as home_team_points_off_turnover
    from {{ ref('fct_offensive_actions_indicators') }} as oai
    left join home_away_teams as hat
        on
            oai.season = hat.season
            and oai.game_id = hat.game_id
            and oai.team_code = hat.home_team_code
    where oai.season = 2023 and oai.flag_home_team = 1

),

away_offensive_2023 as (

    select
        oai.season,
        oai.game_id,
        hat.away_team,
        oai.team_code as away_team_code,
        oai.fastbreak as away_team_fastbreak,
        oai.second_chance as away_team_second_chance,
        oai.points_off_turnover as away_team_points_off_turnover
    from {{ ref('fct_offensive_actions_indicators') }} as oai
    left join home_away_teams as hat
        on
            oai.season = hat.season
            and oai.game_id = hat.game_id
            and oai.team_code = hat.away_team_code
    where oai.season = 2023 and oai.flag_home_team = 0

)

select
    ho.season,
    ho.game_id,
    ho.home_team,
    ho.home_team_code,
    ao.away_team,
    ao.away_team_code,
    ho.home_team_fastbreak,
    ho.home_team_second_chance,
    ho.home_team_points_off_turnover,
    ao.away_team_fastbreak,
    ao.away_team_second_chance,
    ao.away_team_points_off_turnover
from home_offensive_2023 as ho
left join away_offensive_2023 as ao
    on
        ho.season = ao.season
        and ho.game_id = ao.game_id
