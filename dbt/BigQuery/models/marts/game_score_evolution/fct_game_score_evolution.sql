
/* Fact table including game score evolution: (i) home and away points; (ii) score difference */ 

with 

game_scores as (

    select 
        season, 
        game_id, 
        points_home, 
        points_away,
        points_home - points_away as home_away_score_difference,   
        points_home + points_away as home_away_combined_points 
    from {{ ref('stg_play_by_play') }}  
    order by season, game_id, home_away_combined_points

)

select * 
from game_scores 
order by season, game_id, home_away_combined_points


