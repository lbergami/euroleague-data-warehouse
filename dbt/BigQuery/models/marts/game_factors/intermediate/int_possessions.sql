/* Teams' possessions */

with

off_reb_pcts as (

    select
        season,
        game_id,
        home_game_factor as home_off_reb_pct,
        away_game_factor as away_off_reb_pct
    from {{ ref('int_rebounds_pct') }}
    where key_game_factor = 'OREB %'

),

/* Select relevant variables */
selected_variables as (

    select
        bs.season,
        bs.game_id,
        bs.flag_home_team,
        bs.free_throws_attempted as fta,
        bs.turnovers,
        orp.home_off_reb_pct as home_off_reb_pct,
        orp.away_off_reb_pct as away_off_reb_pct,
        bs.field_goals_attempted_2 + field_goals_attempted_3 as fga,
        bs.field_goals_made_2 + field_goals_made_3 as fgm
    from {{ ref('int_box_scores_by_team') }} as bs
    left join off_reb_pcts as orp
        on bs.season = orp.season and bs.game_id = orp.game_id

),

/* Number of possessions home team */
poss_per_game_team_home as (

    select
        season,
        game_id,
        fga
        + (0.44 * fta)
        - (1.07 * home_off_reb_pct * (fga - fgm))
        + turnovers as home_possession
    from selected_variables
    where flag_home_team = TRUE

),

/* Number of possessions home team */
poss_per_game_team_away as (

    select
        season,
        game_id,
        fga
        + (0.44 * fta)
        - (1.07 * away_off_reb_pct * (fga - fgm))
        + turnovers as away_possession
    from selected_variables
    where flag_home_team = FALSE

)

select
    h.season,
    h.game_id,
    'Possessions' as key_game_factor,
    h.home_possession as home_game_factor,
    a.away_possession as away_game_factor
from poss_per_game_team_home as h
left join poss_per_game_team_away as a
    on h.season = a.season and h.game_id = a.game_id
