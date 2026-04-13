% Parameters
float: time_sulfate = 0.5;
float: time_ginger  = 0.75;

int: min_sulfate = 100;
int: total_units = 400;

% Variables
var 0..total_units: sulfate;
var 0..total_units: ginger;

var float: total_time;

% Constraints
constraint sulfate + ginger = total_units;
constraint sulfate >= min_sulfate;
constraint sulfate <= 2 * ginger;

constraint total_time = time_sulfate * sulfate + time_ginger * ginger;

% Objective
solve minimize total_time;