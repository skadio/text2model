% Parameters
int: min_total_shifts = 10;
int: max_excess = 4;
int: cost_x = 8;
int: cost_y = 5;

% Variables
var 0..1000: x_shifts;
var 0..1000: y_shifts;
var 0..100000: total_cost;

% Constraints
constraint x_shifts + y_shifts >= min_total_shifts;
constraint x_shifts - 2 * y_shifts <= max_excess;
constraint total_cost = cost_x * x_shifts + cost_y * y_shifts;

% Objective
solve minimize total_cost;