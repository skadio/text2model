% Parameters
int: budget = 10000;
int: minX = 2000;
int: minY = 3000;
float: costX = 0.02;
float: costY = 0.03;

% Variables
var minX..budget: x;
var minY..budget: y;
var float: total_cost;

% Constraints
constraint x + y <= budget;
constraint total_cost = costX * int2float(x) + costY * int2float(y);

% Objective
solve minimize total_cost;