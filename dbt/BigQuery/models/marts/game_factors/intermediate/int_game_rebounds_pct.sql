
/* Rebound percentages */

/* Number of Rebounds Home team */

with 

reb_per_game_team_home as (

    select
        season, 
        game_id, 
        defensive_rebounds as game_home_defensive_rebounds, 
        offensive_rebounds as game_home_offensive_rebounds
    from {{ ref('int_box_scores_by_team') }}
    where flag_home_team = TRUE

),

/* Number of Rebounds Away team */

reb_per_game_team_away as (

    select
        season, 
        game_id, 
        defensive_rebounds as game_away_defensive_rebounds, 
        offensive_rebounds as game_away_offensive_rebounds
    from {{ ref('int_box_scores_by_team') }}
    where flag_home_team = FALSE

)

/* Create the table */
select
    h.season, 
    h.game_id,
    /* Home team */ 
    game_home_defensive_rebounds / (game_home_defensive_rebounds +  game_away_offensive_rebounds) as home_def_reb_pct, 
    game_home_offensive_rebounds / (game_home_offensive_rebounds + game_away_defensive_rebounds) as home_off_reb_pct,
    /* Away team */ 
    game_away_defensive_rebounds / (game_away_defensive_rebounds +  game_home_offensive_rebounds) as away_def_reb_pct, 
    game_away_offensive_rebounds / (game_away_offensive_rebounds + game_home_defensive_rebounds) as away_off_reb_pct,
from reb_per_game_team_home as h
/* Join team away table */ 
left join reb_per_game_team_away as a
    on h.season = a.season and h.game_id = a.game_id
  

