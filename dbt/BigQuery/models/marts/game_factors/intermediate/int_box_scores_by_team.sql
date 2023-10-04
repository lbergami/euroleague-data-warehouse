/* Box score statistics by game and team  */

with

selected_numeric_stats as (

    select
        season,
        game_id,
        team_code,
        flag_home_team,
        sum(points) as points,
        sum(field_goals_made_2) as field_goals_made_2,
        sum(field_goals_attempted_2) as field_goals_attempted_2,
        sum(field_goals_made_3) as field_goals_made_3,
        sum(field_goals_attempted_3) as field_goals_attempted_3,
        sum(free_throws_made) as free_throws_made,
        sum(free_throws_attempted) as free_throws_attempted,
        sum(offensive_rebounds) as offensive_rebounds,
        sum(defensive_rebounds) as defensive_rebounds,
        sum(total_rebounds) as total_rebounds,
        sum(assists) as assists,
        sum(steals) as steals,
        sum(turnovers) as turnovers,
        sum(blocks_favour) as blocks_favour,
        sum(blocks_against) as blocks_against,
        sum(fouls_commited) as fouls_commited,
        sum(fouls_received) as fouls_received,
        sum(valuation) as valuation
    from {{ ref('stg_box_scores') }}
    group by season, game_id, team_code, flag_home_team

)

select *
from selected_numeric_stats
order by season, game_id
