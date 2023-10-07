/* Combine the intermediate models in one game factor model for reporting */

with

games_teams as (

    select *
    from {{ ref('dim_games_and_teams') }}

),

game_factos as (

    select *
    from {{ ref('int_eFG') }}
    union all
    select *
    from {{ ref('int_free_throw_rate') }}
    union all
    select *
    from {{ ref('int_rebounds_pct') }}
    union all
    select *
    from {{ ref('int_possessions') }}
    union all
    select *
    from {{ ref('int_tov_pct') }}
    union all
    select *
    from {{ ref('int_ts_pct') }}    

)

select
    gt.season,
    gt.game_id,
    /* home and away team names */
    gt.home_team,
    gt.away_team,
    gt.home_team_code,
    gt.away_team_code,
    /* game factors */
    gf.key_game_factor, 
    gf.home_game_factor, 
    gf.away_game_factor
from games_teams as gt
left join game_factos as gf
    on gt.season = gf.season and gt.game_id = gf.game_id
