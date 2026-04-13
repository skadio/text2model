% Parameters
int: time_pill = 10;
int: time_shot = 20;
int: total_time = 10000;
int: min_pill = 30;
int: shot_to_pill_ratio = 3;

% Variables
var 0..(total_time div time_pill): pill;
var 0..(total_time div time_shot): shot;
var 0..(total_time div min(time_pill, time_shot)): total_patients;

% Constraints
constraint time_pill * pill + time_shot * shot <= total_time;
constraint shot >= shot_to_pill_ratio * pill;
constraint pill >= min_pill;
constraint total_patients = pill + shot;

% Objective
solve maximize total_patients;