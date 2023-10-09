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

), 

game_teams_factors as (

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

)

select
    season, 
    game_id, 
    home_team, 
    away_team, 
    home_team_code, 
    away_team_code, 
    key_game_factor, 
    /* Convert to % if key not possession */
    /* Home team metric */
    case
        when key_game_factor = 'Possessions' then round(home_game_factor)
        else round(home_game_factor * 100)
    end as home_game_factor, 
    /* Away team metric */ 
    case
        when key_game_factor = 'Possessions' then round(away_game_factor)
        else round(away_game_factor * 100)
    end as away_game_factor, 
    /* Add an id to order keys */
    case 
        when  key_game_factor = 'eFG %' then 1 
        when  key_game_factor = 'TOV %' then 2 
        when  key_game_factor = 'OREB %' then 3 
        when  key_game_factor = 'DREB %' then 4 
        when  key_game_factor = 'FTA Rate' then 5 
        when  key_game_factor = 'TS %' then 6 
        else 7 
    end as key_game_factor_order_id      
from game_teams_factors
