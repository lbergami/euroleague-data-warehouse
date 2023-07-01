
/* Teams' possessions */

with 

/* Select relevant variables */
selected_variables as (

    select
        bs.season, 
        bs.game_id,
        bs.flag_home_team,
        bs.field_goals_attempted_2 + field_goals_attempted_3 as fga, 
        bs.free_throws_attempted as fta, 
        bs.field_goals_made_2 + field_goals_made_3 as fgm, 
        bs.turnovers, 
        gr.home_def_reb_pct as home_def_reb_pct, 
        gr.home_off_reb_pct as home_off_reb_pct,
        gr.away_def_reb_pct as away_def_reb_pct, 
        gr.away_off_reb_pct as away_off_reb_pct
    from {{ ref('int_box_scores_by_team') }} as bs 
    left join {{ ref('int_game_rebounds_pct') }} gr
        on bs.season = gr.season and bs.game_id = gr.game_id
    
),

/* Number of possessions home team */
poss_per_game_team_home as (

    select
        season, 
        game_id, 
        fga + (0.44 * fta) - (1.07 * home_off_reb_pct * (fga - fgm)) + turnovers as home_possession
    from selected_variables
    where flag_home_team = TRUE

), 

/* Number of possessions home team */
poss_per_game_team_away as (

    select
        season, 
        game_id, 
        fga + (0.44 * fta) - (1.07 * away_off_reb_pct * (fga - fgm)) + turnovers as away_possession
    from selected_variables
    where flag_home_team = FALSE

)

select
    h.season, 
    h.game_id,  
    h.home_possession,
    a.away_possession
from poss_per_game_team_home as h 
left join poss_per_game_team_away as a
    on h.season = a.season and h.game_id = a.game_id




