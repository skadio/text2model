% Parameters
int: max_ships = 1000;
int: demand = 800;
int: diff_limit = 200;

int: cost_x = 8;
int: cost_y = 15;

% Variables
var 0..max_ships: x;
var 0..max_ships: y;
var 0..(cost_x*max_ships + cost_y*max_ships): total_cost;

% Constraints
constraint x + y <= max_ships;
constraint 2*x + y >= demand;

% Difference constraint: |x - 0.5*y| <= diff_limit  <=>  |2*x - y| <= 2*diff_limit
constraint abs(2*x - y) <= 2*diff_limit;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;