{{
    config(
        materialized='incremental',
        unique_key='shot_id'
    )
}}

with

source as (

    select * from {{ source('euroleague_data', 'shots_data') }}

),

renamed as (

    select
        cast(shot_id as numeric) as shot_id,
        cast(concat('20', right(season, 2)) as integer) as season,
        cast(game_id as numeric) as game_id,
        cast(num_anot as numeric) as shot_game_id,
        cast(points as numeric) as points,
        cast(coord_x as numeric) as coord_x,
        cast(coord_y as numeric) as coord_y,
        cast(minute as numeric) as minute,
        console,
        cast(points_home as numeric) as points_home,
        cast(points_away as numeric) as points_away,
        case
            when cast(fastbreak as numeric) = 1 then 1
            else 0
        end as fastbreak,
        case
            when cast(second_chance as numeric) = 1 then 1
            else 0
        end as second_chance,
        case
            when cast(points_off_turnover as numeric) = 1 then 1
            else 0
        end as points_off_turnover,
        lower(trim(team)) as team_code,
        lower(trim(id_player)) as player_id,
        lower(trim(player)) as player_name,
        lower(trim(action)) as action,
        lower(trim(id_action)) as action_type,
        lower(trim(zone)) as zone

    from source

    {% if is_incremental() %}

        where shot_id > (select max(shot_id) from {{ this }})

    {% endif %}


)

select * from renamed
