
/* Combine 2p and 3p shooting zones */

with 

/* two-points shots */
two_points_shots as (

    select * 
    from {{ ref('int_2p_shooting_zones') }}

), 

/* three-points shots 
   Shots with missing zone are dropped because treated as two-point shots and included in the 2-point model */

three_points_shots as (

    select 
        season, 
        game_id, 
        shot_id, 
        team, 
        shot_zone, 
        shot_zone_agg, 
        made_shot
    from {{ ref('int_3p_shooting_zones') }}    
    where shot_zone is not null

)

select * 
from two_points_shots
union all
select * 
from three_points_shots





