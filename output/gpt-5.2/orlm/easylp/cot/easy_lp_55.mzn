% Parameters (with values embedded)
int: max_inventory = 5000;
int: demand_min = 3000;
int: balance_max = 2000;

int: cost_X = 20;
int: cost_Y = 10;

% Variables
var 0..max_inventory: X;  % units of product X
var 0..max_inventory: Y;  % units of product Y
var 0..(cost_X*max_inventory + cost_Y*max_inventory): total_cost;

% Constraints
constraint X + Y <= max_inventory;
constraint 2*X + 3*Y >= demand_min;
constraint 5*X - Y <= balance_max;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;