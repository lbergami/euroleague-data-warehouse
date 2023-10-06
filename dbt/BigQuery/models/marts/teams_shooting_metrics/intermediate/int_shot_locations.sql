with

/* Select relevant variables from the stage shot data */
selected_variables_shots as (

    select
        season,
        game_id,
        shot_id,
        team_code,
        action,
        action_type,
        points,
        coord_x,
        coord_y,
        fastbreak,
        second_chance,
        points_off_turnover
    from {{ ref('stg_shots') }}
    /* Exclude FT */
    where action_type != 'ftm'

),

/* Rescale shot locations coordinats based on dashboard court size */
rescaled_shot_locations as (

    select
        season,
        game_id,
        shot_id,
        (coord_x / 98) as coord_x,
        ((coord_y / 98) + 1.575) as coord_y
    from {{ ref('stg_shots') }}

),

/* Group different type of shots in less granular categories */
harmonized_shot_type as (

    select
        season,
        game_id,
        shot_id,
        case
            when action_type = '2fga' then '2fga'
            when action_type = 'layupatt' then '2fga'
            when action_type = '2fgm' then '2fgm'
            when action_type = '3fga' then '3fga'
            when action_type = '3fgm' then '3fgm'
            when action_type = '2fgab' then '2fga'
            when action_type = 'layupmd' then '2fgm'
            when action_type = '3fgab' then '3fga'
            when action_type = 'dunk' then '2fgm'
        end as shot_type
    from selected_variables_shots

),

made_shots as (

    select
        season,
        game_id,
        shot_id,
        case
            when shot_type in ('2fgm', '3fgm') then 1
            when shot_type in ('2fga', '3fga') then 0
        end as made_shot
    from harmonized_shot_type

)

/* Join the data together */
select
    svs.season,
    svs.game_id,
    svs.shot_id,
    svs.team_code,
    rsl.coord_x,
    rsl.coord_y,
    ms.made_shot,
    svs.fastbreak,
    svs.second_chance,
    svs.points_off_turnover,
    case
        when hst.shot_type in ('2fgm', '2fga') then '2p'
        when hst.shot_type in ('3fgm', '3fga') then '3p'
    end as shot_type
from selected_variables_shots as svs
/* Join rescale shot location */
left join rescaled_shot_locations as rsl
    on
        svs.season = rsl.season
        and svs.game_id = rsl.game_id
        and svs.shot_id = rsl.shot_id
/* Join harmonized shot type */
left join harmonized_shot_type as hst
    on
        svs.season = hst.season
        and svs.game_id = hst.game_id
        and svs.shot_id = hst.shot_id
/* Join made shots */
left join made_shots as ms
    on
        svs.season = ms.season
        and svs.game_id = ms.game_id
        and svs.shot_id = ms.shot_id
order by season, game_id, shot_id
