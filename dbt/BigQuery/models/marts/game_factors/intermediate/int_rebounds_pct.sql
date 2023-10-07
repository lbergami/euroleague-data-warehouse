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

), 

OffReb as (

    select
        h.season,
        h.game_id,
        'OREB %' as key_game_factor,
        /* Home team */
        game_home_offensive_rebounds
        / (game_home_offensive_rebounds + game_away_defensive_rebounds)
            as home_game_factor,
        /* Away team */
        game_away_offensive_rebounds
        / (game_away_offensive_rebounds + game_home_defensive_rebounds)
            as away_game_factor
    from reb_per_game_team_home as h
    /* Join team away table */
    left join reb_per_game_team_away as a
        on h.season = a.season and h.game_id = a.game_id

), 

DefReb as (

    select
        h.season,
        h.game_id,
        'DREB %' as key_game_factor,
        /* Home team */
        game_home_defensive_rebounds
        / (game_home_defensive_rebounds + game_away_offensive_rebounds)
            as home_game_factor,
        /* Away team */
        game_away_defensive_rebounds
        / (game_away_defensive_rebounds + game_home_offensive_rebounds)
            as away_game_factor
    from reb_per_game_team_home as h
    /* Join team away table */
    left join reb_per_game_team_away as a
        on h.season = a.season and h.game_id = a.game_id

)

select *
from OffReb
union all
select *
from DefReb
order by season, game_id


