% Parameters
int: cost_X = 5000;
int: cost_Y = 3000;
int: capacity_total = 1000;
int: demand_min = 2000;
int: balance_min_diff = 150;

% Variables
var 0..capacity_total: X;
var 0..capacity_total: Y;
var 0..(cost_X * capacity_total + cost_Y * capacity_total): total_cost;

% Constraints
constraint X + Y <= capacity_total;
constraint 3 * X + 2 * Y >= demand_min;
constraint X - Y >= balance_min_diff;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;