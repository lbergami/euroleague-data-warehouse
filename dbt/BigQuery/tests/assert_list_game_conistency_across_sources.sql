/* This singular test checks whether the three sources contain the same set of games per season */

with

pbp as (

    select distinct
        season,
        game_id,
        1 as table_pbp
    from {{ ref ('stg_play_by_play') }}

),

bs as (

    select distinct
        season,
        game_id,
        1 as table_bs
    from {{ ref ('stg_box_scores') }}

),

s as (

    select distinct
        season,
        game_id,
        1 as table_shots
    from {{ ref ('stg_shots') }}

),

combined_table as (

    select
        coalesce(pbp.season, bs.season, s.season) as season,
        coalesce(pbp.game_id, bs.game_id, s.game_id) as game_id,
        table_pbp,
        table_bs,
        table_shots
    from pbp
    full join bs
        on pbp.season = bs.season and pbp.game_id = bs.game_id
    full join s
        on pbp.season = s.season and pbp.game_id = s.game_id

)

select *
from combined_table
where (table_pbp + table_bs + table_shots) < 3
