% Parameters
int: costX = 50;
int: costY = 10;
int: cap = 200;
int: demand = 50;

% Variables
var 0..cap: x;
var 0..cap: y;
var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint 2*x + y <= cap;
constraint 4*x + y >= demand;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;