/* Free Throw Rate */

with

/* Free Throw rate by game and home team */
home_ftr_per_game_and_team as (

    select
        season,
        game_id,
        free_throws_attempted
        / (
            free_throws_attempted
            + field_goals_attempted_2
            + field_goals_attempted_3
        ) as home_ft_rate
    from {{ ref('int_box_scores_by_team') }}
    where flag_home_team = TRUE

),

/* Free Throw rate by game and away team */
away_ftr_per_game_and_team as (

    select
        season,
        game_id,
        free_throws_attempted
        / (
            free_throws_attempted
            + field_goals_attempted_2
            + field_goals_attempted_3
        ) as away_ft_rate
    from {{ ref('int_box_scores_by_team') }}
    where flag_home_team = FALSE

)

/* Create the final table */
select
    h.season,
    h.game_id,
    'FTA Rate' as key_game_factor,
    h.home_ft_rate as home_game_factor,
    a.away_ft_rate as away_game_factor
from home_ftr_per_game_and_team as h
left join away_ftr_per_game_and_team as a
    on
        h.season = a.season
        and h.game_id = a.game_id
