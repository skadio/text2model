% Parameters
int: pill_time = 10;
int: shot_time = 20;
int: total_time = 10000;
int: min_pills = 30;
int: shot_to_pill_ratio = 3;

% Variables
var 0..(total_time div pill_time): pills;
var 0..(total_time div shot_time): shots;
var 0..(total_time div min(pill_time, shot_time)): total_patients;

% Constraints
constraint pill_time * pills + shot_time * shots <= total_time;
constraint shots >= shot_to_pill_ratio * pills;
constraint pills >= min_pills;
constraint total_patients = pills + shots;

% Objective
solve maximize total_patients;