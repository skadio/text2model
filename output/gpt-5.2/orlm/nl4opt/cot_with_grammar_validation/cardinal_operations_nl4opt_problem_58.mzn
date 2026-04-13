% Parameters
int: time_calcium = 5;
int: time_vitD = 6;
int: min_total_pills = 130;
int: min_vitD_pills = 40;

% Variables
var 0..min_total_pills: calcium;
var 0..min_total_pills: vitD;
var 0..(time_vitD * min_total_pills): total_time;

% Constraints
constraint calcium + vitD >= min_total_pills;
constraint vitD >= min_vitD_pills;
constraint calcium > vitD;

constraint total_time = time_calcium * calcium + time_vitD * vitD;

% Objective
solve minimize total_time;