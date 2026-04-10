% Parameters
int: max_inventory = 5000;
int: demand_min = 3000;
int: balance_max = 2000;

int: cost_x = 20;
int: cost_y = 10;

% Variables
var 0..max_inventory: x;
var 0..max_inventory: y;
var 0..(cost_x*max_inventory + cost_y*max_inventory): total_cost;

% Constraints
constraint x + y <= max_inventory;
constraint 2*x + 3*y >= demand_min;
constraint 5*x - y <= balance_max;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;