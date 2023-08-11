/* Create dimension with an updated version of shot_id given the lack of consistency of the original variable 
   The new formulation is based on seconds remaining in the quarter */ 

with 

selected_variables as (

    select 
        season, 
        game_id, 
        shot_id, 
        /* Convert time console in seconds reamining in the quarter */ 
        (cast(split(console, ':')[ordinal(1)] as numeric) * 60) + cast(split(console, ':')[ordinal(2)] as numeric) as seconds_left_period,
        points_home + points_away as points 
    from {{ ref('stg_shots') }}

)

select 
    season, 
    game_id, 
    shot_id, 
    row_number() over(partition by season, game_id order by points, seconds_left_period desc) as shot_id_new
from selected_variables  