% Tourism resource allocation (integer optimization)
% Embed all data directly as required.

int: budget = 200;
int: minPerf = 400;
int: minDiff = 50;

int: costX = 500;
int: costY = 300;

var 0..budget: X;   % resources for service X
var 0..budget: Y;   % resources for service Y

% Constraints
constraint X + Y <= budget;
constraint 3*X + 2*Y >= minPerf;
constraint abs(X - Y) >= minDiff;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];