% Parameters
int: max_total_resources = 1000;
int: coef_x = 2;
int: coef_y = 3;
int: min_diff_xy = 100; % X at least 100 more than Y
int: reduction_x = 5;
int: reduction_y = 7;

% Variables
var 0..(max_total_resources div coef_x): x; % resources allocated to project X
var 0..(max_total_resources div coef_y): y; % resources allocated to project Y
var int: total_cost;

% Constraints
constraint coef_x * x + coef_y * y <= max_total_resources;
constraint x >= y + min_diff_xy;

% Total "cost" minimized is negative of total reduction (baseline not given),
% so minimizing cost is equivalent to maximizing reduction.
constraint total_cost = -(reduction_x * x + reduction_y * y);

% Objective
solve minimize total_cost;