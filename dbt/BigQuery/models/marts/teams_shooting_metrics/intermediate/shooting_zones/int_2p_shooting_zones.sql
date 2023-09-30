
with 

/* Extract 2-point shots from shot location model */
two_points_shots_raw as (

    select 
        season, 
        game_id,
        shot_id,
        team_code,
        made_shot,   
        coord_x, 
        coord_y
    from {{ ref('int_shot_locations') }}
    where shot_type = '2p'

),

/* Extract 2-point shots from 3-point shots list (misallocated) */
additional_two_points_shots as (

    select 
        season, 
        game_id,
        shot_id,
        team_code,
        made_shot,   
        coord_x, 
        coord_y
    from {{ ref('int_3p_shooting_zones') }}
    where shot_zone is null

),

/* Combine the two lists of shots */ 
two_points_shots as (

    select * 
    from two_points_shots_raw
    union all
    select * 
    from additional_two_points_shots

), 

two_points_shots_zones as (

    select
        season, 
        game_id, 
        shot_id, 
        team_code, 
        made_shot,   
        case
        /* Shot outside the paint */ 
            when coord_x < -2.45 and coord_y <= 2 then 'l_baseline_2p'
            when coord_x < -2.45 and coord_y > 2 then 'l_wing_2p'
            when (coord_x >= -2.45 and coord_x <= 2.45) and coord_y >= 5.8 then 'central_2p'
            when coord_x > 2.45 and coord_y > 2 then 'r_wing_2p'
            when coord_x > 2.45 and coord_y <= 2 then 'r_baseline_2p'
        /* Shot inside the paint */ 
            when (coord_x >= -2.45 and coord_x < 0) and (coord_y >= 2 and coord_y < 5.8) then 'l_high_paint_2p'
            when (coord_x >= 0 and coord_x <= 2.45) and (coord_y >= 2 and coord_y < 5.8) then 'r_high_paint_2p'
            when (coord_x >= -2.45 and coord_x < 0) and (coord_y >= 0 and coord_y < 2) then 'l_low_paint_2p'
            when (coord_x >= 0 and coord_x <= 2.45) and (coord_y >= 0 and coord_y < 2) then 'r_low_paint_2p'
        end as shot_zone
        from two_points_shots

),

two_points_shots_zones_agg as (

    select
        season, 
        game_id, 
        shot_id, 
        case
            when shot_zone in ('l_baseline_2p', 'r_baseline_2p') then 'baseline_2p'
            when shot_zone in ('l_wing_2p', 'r_wing_2p') then 'wing_2p'
            when shot_zone = 'central_2p' then 'central_2p'
            when shot_zone in ('l_high_paint_2p', 'r_high_paint_2p') then 'high_paint_2p'
            when shot_zone in ('l_low_paint_2p', 'r_low_paint_2p') then 'low_paint_2p'
        end as shot_zone_agg
        from two_points_shots_zones

)

select 
    sz.season, 
    sz.game_id, 
    sz.shot_id, 
    sz.team_code, 
    sz.shot_zone, 
    sza.shot_zone_agg, 
    sz.made_shot  
from two_points_shots_zones as sz
left join two_points_shots_zones_agg as sza
    on sz.season = sza.season and sz.game_id = sza.game_id and sz.shot_id = sza.shot_id 