% Parameters
int: capacity_total = 1000;
int: demand_min = 800;
int: balance_max = 200;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..capacity_total: X;
var 0..capacity_total: Y;
var 0..(cost_x * capacity_total + cost_y * capacity_total): total_cost;

% Constraints
constraint X + Y <= capacity_total;
constraint 2 * X + Y >= demand_min;
constraint abs(X - 2 * Y) <= balance_max;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;