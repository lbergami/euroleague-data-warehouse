# Euroleage data documentation

This file contains docs blocks for project documentation 

## Staging models

### Box Scores Table

This section contains documentation from the Box scores table

{% docs box_scores_id %}
Unique identifier of the box score entry
{% enddocs %}

{% docs season %}
Season of the game
{% enddocs %}

{% docs game_id %}
Numeric identifier of the game withing the season. The number match the game Id in the Euroleague website
{% enddocs %}

{% docs team_code %}
Alphabetic code identifying the team
{% enddocs %}

{% docs flag_home_team %}
Indicator to flag whether the team is playing at home or away
{% enddocs %}

{% docs player_id %}
Id of the player
{% enddocs %}

{% docs player_name %}
First and second name of the player
{% enddocs %}

{% docs dorsal %}
Player jersey's number
{% enddocs %}

{% docs flag_starting_five %}
Indicator to flag whether the player has starting the game on the court or on the bench
{% enddocs %}

{% docs minutes %}
Number of minutes played by the player in the game
{% enddocs %}

{% docs points %}
Number of points scored by the player in the game
{% enddocs %}

{% docs field_goals_made_2 %}
Number of 2-points shot scored by the player in the game
{% enddocs %}

{% docs field_goals_attempted_2 %}
Number of 2-points shot attempted by the player in the game
{% enddocs %}

{% docs field_goals_made_3 %}
Number of 3-points shot scored by the player in the game
{% enddocs %}

{% docs field_goals_attempted_3 %}
Number of 3-points shot attempted by the player in the game
{% enddocs %}

{% docs free_throws_made %}
Number of FTs scored by the player in the game
{% enddocs %}

{% docs free_throws_attempted %}
Number of FTs attempted by the player in the game
{% enddocs %}

{% docs offensive_rebounds %}
Number of OR grabbed by the player in the game
{% enddocs %}

{% docs defensive_rebounds %}
Number of DR grabbed by the player in the game
{% enddocs %}

{% docs total_rebounds %}
Number of OR + DR grabbed by the player in the game
{% enddocs %}

{% docs assists %}
Number of assists made by the player in the game
{% enddocs %}

{% docs steals %}
Number of steals made by the player in the game
{% enddocs %}

{% docs turnovers %}
Number of turnovers made by the player in the game
{% enddocs %}

{% docs blocks_favour %}
Number of blocks made by the player in the game
{% enddocs %}

{% docs blocks_against %}
Number of blocks received by the player in the game
{% enddocs %}

{% docs fouls_commited %}
Number of fouls committed by the player in the game
{% enddocs %}

{% docs fouls_received %}
Number of fouls received by the player in the game
{% enddocs %}

{% docs valuation %}
Player's valuation of the game
{% enddocs %}

### Play-by-Play Table

This section contains documentation from the Play-by-play table.

{% docs play_by_play_id %}
Unique identifier of the play by play instance  
{% enddocs %}

{% docs team %}
Full team name
{% enddocs %}

{% docs game_play_id %}
Numeric id identifying event within the game
{% enddocs %}

{% docs playinfo %}
Description of the event / play made
{% enddocs %}

{% docs playtype %}
Code associated with playinfo
{% enddocs %}

{% docs minute %}
Minute of the game
{% enddocs %}

{% docs markertime %}
Time clock in the period
{% enddocs %}

{% docs markertime_seconds %}
Time clock in the period, in seconds
{% enddocs %}

{% docs game_period %}
Period of the game
{% enddocs %}

{% docs shot_clock %}
Second before shot clock expiration
{% enddocs %}

{% docs points_home %}
Points made by the home team up to that point in the game  
{% enddocs %}

{% docs points_away %}
Points made by the away team up to that point in the game
{% enddocs %}

### Shots Table

This section contains documentation from shots table.

{% docs shot_id %}
Unique identifier of the shot taken
{% enddocs %}

{% docs action %}
Description of the shot, e.g. 2P/3P and made/missed
{% enddocs %}

{% docs action_type %}
alphabetic code associated to action
{% enddocs %}

{% docs shot_points %}
Points related to the shot  
{% enddocs %}

{% docs coord_x %}
x coord of the shot
{% enddocs %}

{% docs coord_y %}
y coord of the shot
{% enddocs %}

{% docs zone %}
Zone of the court the shot is taken. This variable is going to be ignored and zone are going to be defined by coordinates only
{% enddocs %}

{% docs fastbreak %}
Whether the shot is taken after a fastbreak or not
{% enddocs %}

{% docs second_chance %}
Whether the shot is taken after as an offensive rebounds or not
{% enddocs %}

{% docs points_off_turnover %}
Whether the shot is taken off a turnover
{% enddocs %}

{% docs console %}
Time left on the clock when the shot is taken
{% enddocs %}

## Data Marts 

### General game - team dimension tables 

{% docs home_team %}
Name of the team playing at home 
{% enddocs %}

{% docs away_team %}
Name of the team playing away
{% enddocs %}

{% docs home_team_score %}
Total points scored by the team playing at home
{% enddocs %}

{% docs away_team_score %}
Total points scored by the team playing away
{% enddocs %}

{% docs home_team_code %}
3-Letter code identifying the team playing at home 
{% enddocs %}

{% docs away_team_code %}
3-Letter code identifying the team playing away
{% enddocs %}

### Game factors 

{% docs home_efg %}
Home team effective goal percentage. The formula is The formula is (FG + 0.5 * 3P) / FGA, where:
FG = Field goals (incl. both 2-point and 3-point goals)
3P = 3-point field goals 
FGA = Field Goal Attempts (incl. both 2-point and 3-point field goal attempts)
This statistic adjusts for the fact that a 3-point field goal is worth one more point than a 2-point field goal. 
{% enddocs %}

{% docs away_efg %}
Away team effective goal percentage
{% enddocs %}

{% docs home_ft_rate %}
Home team free throw rate
{% enddocs %}

{% docs away_ft_rate %}
Away team free throw rate
{% enddocs %}

{% docs home_def_reb_pct %}
Home team percentage of defensive rebounds. The formula includes the number of rebounds got by the away team  
{% enddocs %}

{% docs home_off_reb_pct %}
Home team percentage of offensive rebounds. The formula includes the number of rebounds got by the home team 
{% enddocs %}

{% docs away_def_reb_pct %}
Away team percentage of defensive rebounds 
{% enddocs %}

{% docs away_off_reb_pct %}
Away team percentage of defensive rebounds
{% enddocs %}

{% docs home_possession %}
Home team number of possessions. This formula estimates possessions based on both the team's statistics and their opponent's statistics, then averages them to provide a more stable estimate.
{% enddocs %}

{% docs away_possession %}
Away team number of possessions
{% enddocs %}

{% docs home_tov_pct %}
Home team turnover percentage. Estimate of turnovers per 100 plays. The formula is 100 * TOV / (FGA + 0.44 * FTA + TOV), where TOV is the number of turnover per game
{% enddocs %}

{% docs away_tov_pct %}
Aeay team turnover percentage
{% enddocs %}

{% docs home_ts_pct %}
Home team true shooting percentage. Measure of shooting efficiency that takes into account field goals, 3-point goals, and free throws. 
Points / (2 * TSA), where TSA is the true shooting attempt equal to FGA + 0.44 * FTA.
FGA = Field Goal Attempts (incl. both 2-point and 3-point field goal attempts)
FTA = Free Throw Attempts    
{% enddocs %}

{% docs away_ts_pct %}
Away team true shooting percentage
{% enddocs %}

### Team shooting metrics  

{% docs shot_zone_label %}
Shooting zone area based on shooting coordinates 
{% enddocs %}

{% docs shooting_selection_pct %}
Team's percentage of shots by shoot zone, per game  
{% enddocs %}

{% docs shooting_pct %}
Team's percentage of made shots by shoot zone, per game  
{% enddocs %}

{% docs shot_zone_ordered_num_label %}
Numeric indicator to order the shoot_zone_label
{% enddocs %}


















