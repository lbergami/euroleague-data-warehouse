
with 

shot_zones_names as (

    select 
        distinct shot_zone_agg
    from {{ ref('int_shooting_zones') }}

)
select 
    shot_zone_agg, 
    initcap(replace(shot_zone_agg, '_', ' ')) as shot_zone_label,
    case 
        when shot_zone_agg = 'baseline_3p' then 1
        when shot_zone_agg = 'wing_3p' then 2
        when shot_zone_agg = 'central_3p' then 3
        when shot_zone_agg = 'baseline_2p' then 4
        when shot_zone_agg = 'wing_2p' then 5
        when shot_zone_agg = 'central_2p' then 6
        when shot_zone_agg = 'low_paint_2p' then 7
        when shot_zone_agg = 'high_paint_2p' then 8
    end as shot_zone_ordered_num_label    
from shot_zones_names

