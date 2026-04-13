% Parameters
int: storage_cap = 5000;
int: demand_min = 3000;
int: balance_max = 2000;

int: cost_x = 20;
int: cost_y = 10;

% Variables
var 0..storage_cap: x;  % units of product X
var 0..storage_cap: y;  % units of product Y
var 0..(cost_x * storage_cap + cost_y * storage_cap): total_cost;

% Constraints
constraint x + y <= storage_cap;
constraint 2 * x + 3 * y >= demand_min;
constraint 5 * x - y <= balance_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;