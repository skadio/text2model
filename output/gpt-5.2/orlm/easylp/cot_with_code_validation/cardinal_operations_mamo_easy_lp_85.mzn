% Parameters
int: min_total_shifts = 10;
int: wage_x = 8;
int: wage_y = 5;
int: max_excess = 4;

% Variables
var 0..min_total_shifts: x_shifts;
var 0..min_total_shifts: y_shifts;
var 0..(wage_x*min_total_shifts + wage_y*min_total_shifts): total_cost;

% Constraints
constraint x_shifts + y_shifts >= min_total_shifts;
constraint x_shifts - 2*y_shifts <= max_excess;

constraint total_cost = wage_x * x_shifts + wage_y * y_shifts;

% Objective
solve minimize total_cost;