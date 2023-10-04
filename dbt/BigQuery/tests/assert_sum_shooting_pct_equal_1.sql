/* This singular test checks whether 'shooting_pct' per game and team correctly sums up to 1  */

with

missed_shots_pct as (

    select
        isz.season,
        isz.game_id,
        isz.team_code,
        l.shot_zone_label,
        count(case when isz.made_shot = 0 then isz.shot_id end)
        / (count(case when isz.made_shot = 1 then isz.shot_id end) + count(case when isz.made_shot = 0 then isz.shot_id end))
            as missed_shots_pct
    from {{ ref('int_shooting_zones') }} as isz
    /* Join the lookup with clean label for shooting areas */
    left join {{ ref('dim_shot_zones_labels') }} as l
        on isz.shot_zone_agg = l.shot_zone_agg
    group by isz.season, isz.game_id, isz.team_code, l.shot_zone_label



)

select
    fsp.season,
    fsp.game_id,
    fsp.team_code,
    fsp.shot_zone_label,
    fsp.shooting_pct + msp.missed_shots_pct
from {{ ref('fct_shooting_pct') }} as fsp
left join missed_shots_pct as msp
    on
        fsp.season = msp.season and fsp.game_id = msp.game_id
        and fsp.team_code = msp.team_code and fsp.shot_zone_label = msp.shot_zone_label
where (fsp.shooting_pct + msp.missed_shots_pct) != 1
