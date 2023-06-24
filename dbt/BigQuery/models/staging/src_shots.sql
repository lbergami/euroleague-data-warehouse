with 

source as (

    select * from {{ source('euroleague_data', 'shots_data') }}

),

renamed as (

    select
        num_anot,
        team,
        id_player,
        player,
        id_action,
        action,
        points,
        coord_x,
        coord_y,
        zone,
        fastbreak,
        second_chance,
        points_off_turnover,
        minute,
        console,
        points_home,
        points_away,
        game_id,
        season

    from source

)

select * from renamed