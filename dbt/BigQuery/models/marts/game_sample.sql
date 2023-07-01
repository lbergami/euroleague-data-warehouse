

select *
from {{ ref('stg_play_by_play') }}
where season = '2022-23' and game_id = 1