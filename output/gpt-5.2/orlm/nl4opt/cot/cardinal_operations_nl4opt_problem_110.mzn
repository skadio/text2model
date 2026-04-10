% Parameters (with values embedded)
int: time_pill = 10;
int: time_shot = 20;
int: total_time = 10000;
int: min_pill = 30;
int: shot_to_pill_ratio = 3;

% Variables
var 0..(total_time div time_pill): pill;
var 0..(total_time div time_shot): shot;

% Constraints
constraint pill >= min_pill;
constraint shot >= shot_to_pill_ratio * pill;
constraint time_pill * pill + time_shot * shot <= total_time;

% Objective
solve maximize pill + shot;