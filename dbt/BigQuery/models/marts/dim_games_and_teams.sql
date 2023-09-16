
/* List of games and teams. For each team, report split by home and away  */

with 

games_and_home_team_code as (

    select 
        distinct
            season, 
            game_id, 
            team_code as home_team_code 
    from {{ ref('stg_box_scores') }}
    where flag_home_team = TRUE
    
), 

games_and_home_team_score as (

    select
        season, 
        game_id, 
        sum(points) as home_team_score 
    from {{ ref('stg_box_scores') }}
    group by season, game_id, flag_home_team
    having flag_home_team = TRUE

),

games_and_away_team_code as (

    select 
        distinct
            season, 
            game_id, 
            team_code as away_team_code 
    from {{ ref('stg_box_scores') }}
    where flag_home_team = FALSE
    
), 

games_and_away_team_score as (

    select
        season, 
        game_id, 
        sum(points) as away_team_score 
    from {{ ref('stg_box_scores') }}
    group by season, game_id, flag_home_team
    having flag_home_team = FALSE

),

games_and_team_full_names_home as (

    select 
        distinct
            season,
            game_id,
            team_code as home_team_code,
            initcap(team) as home_team 
    from {{ ref('stg_play_by_play') }}
    where team is not NULL
    order by season, game_id

), 

games_and_team_full_names_away as(

    select 
        distinct
            season,
            game_id,
            team_code as away_team_code,
            initcap(team) as away_team 
    from {{ ref('stg_play_by_play') }}
    where team is not NULL
    order by season, game_id

)

select
    htc.season, 
    htc.game_id, 
    /* Full team names */
    hn.home_team,
    an.away_team, 
    /* Full time score */
    hts.home_team_score,
    ats.away_team_score,
    /* Team codes */
    htc.home_team_code, 
    atc.away_team_code 
from games_and_home_team_code as htc
left join games_and_away_team_code as atc
    on htc.season = atc.season and htc.game_id = atc.game_id
/* Join home/away team full names */
left join games_and_team_full_names_home as hn
    on htc.season = hn.season and htc.game_id = hn.game_id and htc.home_team_code = hn.home_team_code
left join games_and_team_full_names_away as an
    on htc.season = an.season and htc.game_id = an.game_id and atc.away_team_code = an.away_team_code
/* Join home/away team score */
left join games_and_home_team_score as hts
    on htc.season = hts.season and htc.game_id = hts.game_id 
left join games_and_away_team_score as ats
    on htc.season = ats.season and htc.game_id = ats.game_id 
order by season, game_id 


    
