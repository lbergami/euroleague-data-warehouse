with

/* Import dimension table with home/away indicator */
home_away_teams as (

    select *
    from {{ ref('dim_games_home_away_teams') }}

)

select
    sl.season,
    sl.game_id,
    sl.team_code,
    sl.coord_x,
    sl.coord_y,
    sl.made_shot,
    hat.flag_home_team
from {{ ref('int_shot_locations') }} as sl
left join home_away_teams as hat
    on
        sl.season = hat.season
        and sl.game_id = hat.game_id
        and sl.team_code = hat.team_code
