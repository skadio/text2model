% Parameters
int: max_ships = 1000;
int: min_capacity = 800;
int: max_diff = 200;

int: cost_x = 8;
int: cost_y = 15;

% Variables
var 0..max_ships: x;
var 0..max_ships: y;
var 0..(cost_x*max_ships + cost_y*max_ships): total_cost;

% Constraints
constraint x + y <= max_ships;

constraint 2*x + y >= min_capacity;

constraint x - (y div 2) <= max_diff;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;