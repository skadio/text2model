% Parameters
int: max_hours = 40;
int: min_output = 20;
int: output_per_hour_X = 2;
int: output_per_hour_Y = 1;
int: cost_per_hour_X = 8;
int: cost_per_hour_Y = 6;

% Variables
var 0..max_hours: X;
var 0..max_hours: Y;
var 0..(cost_per_hour_X * max_hours + cost_per_hour_Y * max_hours): total_cost;

% Constraints
constraint X + Y <= max_hours;
constraint output_per_hour_X * X + output_per_hour_Y * Y >= min_output;
constraint total_cost = cost_per_hour_X * X + cost_per_hour_Y * Y;

% Objective
solve minimize total_cost;