% Parameters
int: max_items = 200;
int: min_demand = 150;

int: demand_x = 3;
int: demand_y = 2;

int: cost_x = 5;
int: cost_y = 10;

% Variables
var 0..max_items: x;
var 0..max_items: y;
var 0..(cost_x * max_items + cost_y * max_items): total_cost;

% Constraints
constraint x + y <= max_items;
constraint demand_x * x + demand_y * y >= min_demand;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;