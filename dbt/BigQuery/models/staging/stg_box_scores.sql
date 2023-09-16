with 

source as (

    select * from {{ source('euroleague_data', 'box_scores_data') }}

),

renamed as (

    select
        box_scores_id, 
        cast(concat('20', right(season, 2)) as numeric) as season,
        game_id,
        lower(trim(team)) as team_code,
        flaghometeam as flag_home_team,
        lower(trim(player_id)) as player_id,
        lower(trim(player)) as player_name,
        dorsal,
        cast(isstarter as numeric) as flag_starting_five,
        minutes,
        cast(points as numeric) as points, 
        cast(fieldgoalsmade2 as numeric) as field_goals_made_2, 
        cast(fieldgoalsattempted2 as numeric) as field_goals_attempted_2,
        cast(fieldgoalsmade3 as numeric) as field_goals_made_3,
        cast(fieldgoalsattempted3 as numeric) field_goals_attempted_3,
        cast(freethrowsmade as numeric) as free_throws_made,
        cast(freethrowsattempted as numeric) as free_throws_attempted,
        cast(offensiverebounds as numeric) offensive_rebounds,
        cast(defensiverebounds as numeric) as defensive_rebounds,
        cast(totalrebounds as numeric) as total_rebounds,
        cast(assistances as numeric) as assists,
        cast(steals as numeric) as steals,
        cast(turnovers as numeric) as turnovers,
        cast(blocksfavour as numeric) as blocks_favour,
        cast(blocksagainst as numeric) as blocks_against,
        cast(foulscommited as numeric) as fouls_commited,
        cast(foulsreceived as numeric) as fouls_received,
        cast(valuation as numeric) as valuation

    from source

)

select * from renamed