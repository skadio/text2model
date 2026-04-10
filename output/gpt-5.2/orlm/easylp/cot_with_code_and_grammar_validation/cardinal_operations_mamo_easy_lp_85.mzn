% Parameters
int: min_total_shifts = 10;
int: cost_x = 8;
int: cost_y = 5;
int: balance_offset = 4;

% Variables
var 0..1000: x_shifts;
var 0..1000: y_shifts;
var 0..1000000: total_cost;

% Constraints
constraint x_shifts + y_shifts >= min_total_shifts;

% "type X should not exceed twice type Y by more than 4"  =>  x <= 2*y + 4
constraint x_shifts <= 2 * y_shifts + balance_offset;

constraint total_cost = cost_x * x_shifts + cost_y * y_shifts;

% Objective
solve minimize total_cost;