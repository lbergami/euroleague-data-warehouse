
/* Dimensiopn table including home/away indicator for each game, with a granularity season-game-team */

with 

home_away_teams as (

    select   
        season, 
        game_id, 
        team,
        case
            when label = 'home_team_code' then 1
            when label = 'away_team_code' then 0
        end as flag_team_home 
    from (select
            season, 
            game_id, 
            home_team_code, 
            away_team_code
          from {{ ref('dim_games_and_teams') }})
          UNPIVOT(team FOR label IN (home_team_code, away_team_code))

) 

select *
from home_away_teams 

