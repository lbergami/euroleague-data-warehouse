
/* Teams' shot selection percentages and shooting percentages */ 

with 

/* Import dimension table with home/away indicator */ 
home_away_teams as (
    
    select *
    from {{ ref('dim_games_home_away_teams') }}
    
),

/* Create tables for shooting data */
selected_variables as (

    select 
        season, 
        game_id, 
        team, 
        shot_zone_agg, 
        made_shot
    from {{ ref('int_shooting_zones') }}

), 

total_shots_per_game_by_team as (

    select
        season, 
        game_id, 
        team, 
        count(*) as tot_team_shots 
    from selected_variables
    group by 1, 2, 3

), 

n_shots_zone_per_game_by_team as (

    select
        season, 
        game_id, 
        team,
        shot_zone_agg, 
        count(*) as n_team_shots_by_zone 
    from selected_variables
    group by 1, 2, 3, 4

), 

n_made_shots_zone_per_game_by_team as (

    select
        season, 
        game_id, 
        team,
        shot_zone_agg, 
        count(*) as n_team_made_shots_by_zone 
    from selected_variables
    group by 1, 2, 3, 4, made_shot
    having made_shot = 1

), 

game_team_shooting as (

    select 
        zs.season, 
        zs.game_id, 
        zs.team,
        zs.shot_zone_agg as shot_zone, 
        ts.tot_team_shots, 
        zs.n_team_shots_by_zone, 
        case
            when mzs.n_team_made_shots_by_zone is null then 0
            else mzs.n_team_made_shots_by_zone
        end as n_team_made_shots_by_zone    
    from n_shots_zone_per_game_by_team as zs 
    /* Join total game-team shots */ 
    left join total_shots_per_game_by_team as ts
        on zs.season = ts.season and zs.game_id = ts.game_id and zs.team = ts.team
    /* Join made game-team shots by shooting zones */ 
    left join n_made_shots_zone_per_game_by_team as mzs
        on zs.season = mzs.season and zs.game_id = mzs.game_id and zs.team = mzs.team and zs.shot_zone_agg = mzs.shot_zone_agg   

)

select 
    gts.season, 
    gts.game_id, 
    gts.team,
    l.shot_zone_label, 
    gts.n_team_shots_by_zone / gts.tot_team_shots as shooting_selection_pct,     
    gts.n_team_made_shots_by_zone / gts.n_team_shots_by_zone as shooting_pct, 
    hat.flag_team_home,
    l.shot_zone_ordered_num_label    
from game_team_shooting as gts
/* Add shot zones labels */
left join {{ ref('dim_shot_zones_labels') }} as l
    on gts.shot_zone = l.shot_zone_agg
/* Add home/away indicator */
left join home_away_teams as hat
    on gts.season = hat.season and gts.game_id = hat.game_id and gts.team = hat.team
order by season, game_id, team, shot_zone_ordered_num_label   



    



