with 

source as (

    select * from {{ source('euroleague_data', 'play_by_play_data') }}

),

renamed as (

    select
        play_by_play_id, 
        cast(concat('20', right(season, 2)) asnumeric) as season,
        game_id,
        lower(trim(player_id)) as player_id,
        lower(trim(player)) as player_name,
        dorsal,
        lower(trim(codeteam)) as team_code,
        lower(trim(team)) as team,
        game_play_id,
        lower(trim(playinfo)) as playinfo,
        lower(trim(playtype)) as playtype,
        cast(minute as numeric) as minute,
        markertime,
        markertime_seconds,
        game_period,
        shot_clock,
        cast(points_home as numeric) as points_home,
        cast(points_away as numeric) as points_away 
    
    from source

)

select * from renamed