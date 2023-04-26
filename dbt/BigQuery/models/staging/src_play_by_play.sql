select *
from {{ source('euroleague_data', 'play_by_play_data') }}