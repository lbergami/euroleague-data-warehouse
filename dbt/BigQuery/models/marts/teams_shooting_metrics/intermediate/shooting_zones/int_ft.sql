with

made_ft as (

    select
        season,
        game_id,
        team_code,
        fastbreak,
        second_chance,
        points_off_turnover
    from {{ ref('stg_shots') }}
    where action_type = 'ftm'

)

select *
from made_ft
