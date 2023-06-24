with 

source as (

    select * from {{ source('euroleague_data', 'play_by_play_data') }}

),

renamed as (

    select
        codeteam,
        player_id,
        playtype,
        player,
        team,
        dorsal,
        minute,
        markertime,
        points_home,
        points_away,
        playinfo,
        game_period,
        game_id,
        season,
        markertime_seconds,
        game_play_id,
        shot_clock

    from source

)

select * from renamed