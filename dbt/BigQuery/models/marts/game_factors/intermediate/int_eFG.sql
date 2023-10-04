/* Effective field goal percentage */

with

data_per_game_and_team as (

    select
        season,
        game_id,
        team_code,
        flag_home_team,
        field_goals_made_3,
        field_goals_made_2 + field_goals_made_3 as fg,
        field_goals_attempted_2 + field_goals_attempted_3 as fga
    from {{ ref('int_box_scores_by_team') }}

),

/* home eFG by game */
home_efg_per_game_and_team as (

    select
        season,
        game_id,
        (fg + 0.5 * field_goals_made_3) / fga as home_efg
    from data_per_game_and_team
    where flag_home_team = TRUE

),

/* away eFG by game */
away_efg_per_game_and_team as (

    select
        season,
        game_id,
        (fg + 0.5 * field_goals_made_3) / fga as away_efg
    from data_per_game_and_team
    where flag_home_team = FALSE

)

select
    h.season,
    h.game_id,
    h.home_efg,
    a.away_efg
from home_efg_per_game_and_team as h
left join away_efg_per_game_and_team as a
    on h.season = a.season and h.game_id = a.game_id
