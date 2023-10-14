with

home_away_teams as (

    select
        season,
        game_id,
        home_team,
        home_team_code,
        away_team,
        away_team_code
    from {{ ref('dim_games_and_teams') }}

),

home_shot_locations as (

    select
        hsl.season,
        hsl.game_id,
        hsl.shot_id,
        hat.home_team,
        hsl.team_code as home_team_code,
        hat.away_team,
        hat.away_team_code,
        hsl.coord_x,
        hsl.coord_y,
        case when hsl.made_shot = 1 then 'Made' else 'Missed' end as made_shot,
        hsl.flag_home_team
    from {{ ref('fct_shot_locations') }} as hsl
    left join home_away_teams as hat
        on
            hsl.season = hat.season
            and hsl.game_id = hat.game_id
            and hsl.team_code = hat.home_team_code
    where hsl.season > 2022 and hsl.flag_home_team = 1

),

away_shot_locations as (

    select
        asl.season,
        asl.game_id,
        asl.shot_id,
        hat.home_team,
        asl.team_code as away_team_code,
        hat.away_team,
        hat.away_team_code,
        asl.coord_x,
        asl.coord_y,
        case when asl.made_shot = 1 then 'Made' else 'Missed' end as made_shot,
        asl.flag_home_team
    from {{ ref('fct_shot_locations') }} as asl
    left join home_away_teams as hat
        on
            asl.season = hat.season
            and asl.game_id = hat.game_id
            and asl.team_code = hat.away_team_code
    where asl.season > 2022 and asl.flag_home_team = 0

),

home_and_away_shot_locations as (

    select *
    from home_shot_locations
    union all
    select *
    from away_shot_locations

)

select *
from home_and_away_shot_locations
where (coord_x > -8 and coord_x < 8) and (coord_y > 0 and coord_y < 14)
