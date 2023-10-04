/* Turnover Percentage */

with

data_per_game_and_team as (

    select
        season,
        game_id,
        flag_home_team,
        turnovers as tov,
        free_throws_attempted as fta,
        field_goals_attempted_2 + field_goals_attempted_3 as fga
    from {{ ref('int_box_scores_by_team') }}

),

tov_pct_per_game_home_team as (

    select
        season,
        game_id,
        /* Create turnover percentage for home teams */
        tov / (fga + (0.44 * fta) + tov) as home_tov_pct
    from data_per_game_and_team
    where flag_home_team = TRUE

),

tov_pct_per_game_away_team as (

    select
        season,
        game_id,
        /* Create turnover percentage for away teams */
        tov / (fga + (0.44 * fta) + tov) as away_tov_pct
    from data_per_game_and_team
    where flag_home_team = FALSE

)

select
    h.season,
    h.game_id,
    h.home_tov_pct,
    a.away_tov_pct
from tov_pct_per_game_home_team as h
left join tov_pct_per_game_away_team as a
    on h.season = a.season and h.game_id = a.game_id
