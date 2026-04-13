% Parameters
float: time_sulfate = 0.5;
float: time_ginger  = 0.75;

int: min_sulfate = 100;
int: total_units = 400;
int: sulfate_to_ginger_ratio = 2; % sulfate <= 2 * ginger

% Variables
var 0..total_units: sulfate;
var 0..total_units: ginger;

var float: total_time;

% Constraints
constraint sulfate >= min_sulfate;
constraint sulfate + ginger = total_units;
constraint sulfate <= sulfate_to_ginger_ratio * ginger;

constraint total_time = time_sulfate * sulfate + time_ginger * ginger;

% Objective
solve minimize total_time;