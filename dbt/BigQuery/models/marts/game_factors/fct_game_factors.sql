
/* Combine the intermediate tables on game factors in one  */

with 

games_teams as (

    select *
    from {{ ref('dim_games_and_teams') }}

),

efg as (

    select *
    from {{ ref('int_eFG') }}

), 

ftr as (

    select *
    from {{ ref('int_free_throw_rate') }}

), 

grp as (

    select *
    from {{ ref('int_game_rebounds_pct') }}

), 

p as (

    select *
    from {{ ref('int_possessions') }}

), 

tov as (

    select *
    from {{ ref('int_tov_pct') }}

), 

ts as (

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
    /* eFG  */
    efg.home_efg, 
    efg.away_efg,
    /* Free throw rate  */
    ftr.home_ft_rate, 
    ftr.away_ft_rate, 
    /* Rebounds */
    grp.home_def_reb_pct, 
    grp.home_off_reb_pct,
    grp.away_def_reb_pct, 
    grp.away_off_reb_pct,
    /* Ball Possession */
    p.home_possession, 
    p.away_possession, 
    /* Turnovers */
    tov.home_tov_pct, 
    tov.away_tov_pct, 
    /* True shooting */
    ts.home_ts_pct, 
    ts.away_ts_pct
from games_teams as gt
left join efg
    on gt.season = efg.season and gt.game_id = efg.game_id
left join ftr
    on efg.season = ftr.season and efg.game_id = ftr.game_id
left join grp
    on efg.season = grp.season and efg.game_id = grp.game_id
left join p
    on efg.season = p.season and efg.game_id = p.game_id
left join tov
    on efg.season = tov.season and efg.game_id = tov.game_id     
left join ts
    on efg.season = ts.season and efg.game_id = ts.game_id     




















