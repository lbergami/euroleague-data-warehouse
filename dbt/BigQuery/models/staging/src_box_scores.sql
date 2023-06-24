with 

source as (

    select * from {{ source('euroleague_data', 'box_scores_data') }}

),

renamed as (

    select
        player_id,
        isstarter,
        team,
        dorsal,
        player,
        minutes,
        points,
        fieldgoalsmade2,
        fieldgoalsattempted2,
        fieldgoalsmade3,
        fieldgoalsattempted3,
        freethrowsmade,
        freethrowsattempted,
        offensiverebounds,
        defensiverebounds,
        totalrebounds,
        assistances,
        steals,
        turnovers,
        blocksfavour,
        blocksagainst,
        foulscommited,
        foulsreceived,
        valuation,
        flaghometeam,
        game_id,
        season

    from source

)

select * from renamed