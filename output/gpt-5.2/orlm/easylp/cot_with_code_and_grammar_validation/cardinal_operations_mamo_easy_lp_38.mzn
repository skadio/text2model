% Parameters
int: budget = 100000;
int: minX = 10000;
int: minY = 5000;
int: rhsRisk = 20000;
int: costX = 5000;
int: costY = 4000;

% Variables
var minX..budget: x;
var minY..budget: y;
var 0..(costX*budget + costY*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint 3*x - y >= rhsRisk;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;