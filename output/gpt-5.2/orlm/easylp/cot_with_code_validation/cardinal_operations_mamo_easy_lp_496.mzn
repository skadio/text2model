% Parameters
int: total_capacity = 2000;
int: cap_per_x = 4;
int: cap_per_y = 5;

int: min_diff_xy = 50;

int: max_combo = 1500;          % x + 2y <= 1500
int: combo_y_mult = 2;

int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..(total_capacity div cap_per_x): x;
var 0..(total_capacity div cap_per_y): y;

% Constraints
constraint cap_per_x * x + cap_per_y * y <= total_capacity;

constraint x - y >= min_diff_xy;

constraint x + combo_y_mult * y <= max_combo;

% Objective
var 0..(cost_x * (total_capacity div cap_per_x) + cost_y * (total_capacity div cap_per_y)): total_cost;
constraint total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;