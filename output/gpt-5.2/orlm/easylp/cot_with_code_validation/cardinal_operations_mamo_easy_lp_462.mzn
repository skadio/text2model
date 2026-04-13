% Parameters
int: total_max = 1000;
int: capacity_min = 2500;
int: diff_max = 300;

int: cost_x = 7;
int: cost_y = 5;

% Variables
var 0..total_max: x;
var 0..total_max: y;

% Constraints
constraint x + y <= total_max;
constraint 3 * x + 2 * y >= capacity_min;
constraint abs(x - y) <= diff_max;

% Objective
var 0..(cost_x * total_max + cost_y * total_max): total_cost;
constraint total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;