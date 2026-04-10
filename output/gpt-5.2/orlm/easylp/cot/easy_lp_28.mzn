% Parameters (with values embedded)
int: min_vehicles = 10;
int: cap = 25;
int: costX = 5;
int: costY = 7;

% Variables
var 0..25: x;  % number of type X vehicles
var 0..25: y;  % number of type Y vehicles
var 0..(costX*25 + costY*25): total_cost;

% Constraints
constraint x + y >= min_vehicles;
constraint 2*x + 3*y <= cap;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;