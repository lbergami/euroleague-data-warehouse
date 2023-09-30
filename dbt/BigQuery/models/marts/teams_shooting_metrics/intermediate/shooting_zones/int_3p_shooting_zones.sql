
with 

three_points_shots as (

    select 
        season, 
        game_id,
        shot_id, 
        team_code,
        made_shot, 
        coord_x, 
        coord_y
    from {{ ref('int_shot_locations') }}
    where shot_type = '3p'

),

three_points_shots_zones as (

    select
        season, 
        game_id,
        shot_id,  
        coord_x, 
        coord_y,
        team_code,  
        made_shot,
        case
            when coord_x < -6.5 and coord_y <= 3 then 'l_corner_3p'
            when coord_x > 6.5 and coord_y <= 3 then 'r_corner_3p'
            when coord_x < -2.5 and coord_y > 3 then 'l_wing_3p'
            when coord_x > 2.5 and coord_y > 3 then 'r_wing_3p'
            when coord_x >= -2.5 and coord_x <= 2.5 then 'central_3p'
        end as shot_zone
        from three_points_shots

), 

three_points_shots_zones_agg as (

    select
        season, 
        game_id, 
        shot_id, 
        case
            when shot_zone in ('l_corner_3p', 'r_corner_3p') then 'baseline_3p'
            when shot_zone in ('l_wing_3p', 'r_wing_3p') then 'wing_3p'
            when shot_zone = 'central_3p' then 'central_3p'
        end as shot_zone_agg
        from three_points_shots_zones

)

select 
    sz.season, 
    sz.game_id, 
    sz.team_code,  
    sz.shot_id,
    sz.coord_x, 
    sz.coord_y,
    sz.shot_zone, 
    sza.shot_zone_agg, 
    sz.made_shot
from three_points_shots_zones as sz
left join three_points_shots_zones_agg sza
    on sz.season = sza.season and sz.game_id = sza.game_id and sz.shot_id = sza.shot_id 
