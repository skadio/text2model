% Parameters (with values embedded)
int: budget = 10000;
int: minX = 2000;
int: minY = 3000;
float: costX = 0.02;
float: costY = 0.03;

% Variables
var minX..budget: X;
var minY..budget: Y;
var float: total_cost;

% Constraints
constraint X + Y <= budget;
constraint total_cost = costX * int2float(X) + costY * int2float(Y);

% Objective
solve minimize total_cost;