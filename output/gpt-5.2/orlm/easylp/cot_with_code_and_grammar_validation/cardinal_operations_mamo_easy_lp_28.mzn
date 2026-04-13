% Parameters
int: min_vehicles = 10;
int: cap = 25;
int: costX = 5;
int: costY = 7;

% Variables
var 0..cap: x;
var 0..cap: y;
var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint x + y >= min_vehicles;
constraint 2*x + 3*y <= cap;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;