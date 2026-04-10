% Parameters
int: max_total = 20;
int: min_demand = 10;
int: max_balance = 15;

int: cost_x = 5;
int: cost_y = 4;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(cost_x * max_total + cost_y * max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint x + 2 * y >= min_demand;
constraint 2 * x - y <= max_balance;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;