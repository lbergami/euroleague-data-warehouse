/* This singular test checks whether 'shooting_selection_pct' per game and team correctly sums up to 1  */

select
    season,
    game_id,
    team_code,
    round(sum(shooting_selection_pct), 5) as tot_rounded
from {{ ref('fct_shooting_pct') }}
group by 1, 2, 3
having tot_rounded < 1
