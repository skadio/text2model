% Parameters
int: max_ships = 1000;
int: demand = 800;
int: diff_limit = 200;

int: costX = 8;
int: costY = 15;

% Variables
var 0..max_ships: x;
var 0..max_ships: y;
var 0..(costX*max_ships + costY*max_ships): total_cost;

% Constraints
constraint x + y <= max_ships;
constraint 2*x + y >= demand;

% x - 0.5*y <= 200  <=>  2*x - y <= 400
constraint 2*x - y <= 2*diff_limit;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;