% Parameters
int: capacity = 500;
int: minX = 200;
int: minY = 100;

float: costX = 0.05;
float: costY = 0.1;

% Variables
var minX..capacity: X;
var minY..capacity: Y;

var float: totalCost;
var float: totalCostRounded1;

% Constraints
constraint X + Y <= capacity;

constraint totalCost = costX * int2float(X) + costY * int2float(Y);

% round to one decimal place
constraint totalCostRounded1 = int2float(round(totalCost * 10.0)) / 10.0;

% Objective
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (exact) = ", show(totalCost), "\n",
  "Minimum total cost (rounded to 1 decimal) = ", show(totalCostRounded1), "\n"
];