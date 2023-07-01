
/* True shooting percentage by game and team */

with 

data_per_game_and_team as (

    select
        season, 
        game_id, 
        team_code,
        flag_home_team, 
        points as points,
        field_goals_attempted_2 + field_goals_attempted_3 as fga, 
        free_throws_attempted as fta
    from {{ ref('int_box_scores_by_team') }}

),

ts_pct_per_game_home_team as (

    select 
        season, 
        game_id, 
        points / (2 * (fga + (0.44 * fta))) as home_ts_pct
    from data_per_game_and_team 
    where flag_home_team = TRUE   

), 

ts_pct_per_game_away_team as (

    select 
        season, 
        game_id, 
        points / (2 * (fga + (0.44 * fta))) as away_ts_pct
    from data_per_game_and_team 
    where flag_home_team = FALSE   

)

select 
    h.season, 
    h.game_id, 
    h.home_ts_pct, 
    a.away_ts_pct
from ts_pct_per_game_home_team as h
left join ts_pct_per_game_away_team as a
    on h.season = a.season and h.game_id = a.game_id

 
