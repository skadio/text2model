% Parameters
int: max_total_hours = 40;
int: min_output_units = 20;
int: output_x_coeff = 2;
int: output_y_coeff = 1;
int: cost_x = 8;
int: cost_y = 6;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var int: total_cost;

% Constraints
constraint X + Y <= max_total_hours;
constraint output_x_coeff * X + output_y_coeff * Y >= min_output_units;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;