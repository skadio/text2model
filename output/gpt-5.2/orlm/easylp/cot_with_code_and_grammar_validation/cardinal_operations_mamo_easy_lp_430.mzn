% Parameters
int: total_cap = 20;
int: demand_min = 10;
int: balance_max = 15;

int: cost_x = 5;
int: cost_y = 4;

% Variables
var 0..total_cap: x;
var 0..total_cap: y;
var 0..(cost_x * total_cap + cost_y * total_cap): total_cost;

% Constraints
constraint x + y <= total_cap;
constraint x + 2 * y >= demand_min;
constraint 2 * x - y <= balance_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;