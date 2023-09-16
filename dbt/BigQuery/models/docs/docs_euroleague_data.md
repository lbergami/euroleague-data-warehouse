# Euroleage data documentationgame_id

This file contains docs blocks for the three staging tables

## Box Scores Table

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

## Play-by-Play Table

This section contains documentation from the Play-by-play table.

{% docs play_by_play_id}
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

## Shots Table

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
Whether the shot is taken after as a second chance or not
{% enddocs %}

{% docs points_off_turnover %}
Whether the shot is taken off a turnover
{% enddocs %}

{% docs console %}
Time left on the clock when the shot is taken
{% enddocs %}