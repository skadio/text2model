% Energy production planning: minimize cost subject to demand and emission limits

int: costX = 50;
int: costY = 70;

int: demand = 5000;          % minimum total units
int: emX = 10;               % emission per unit of X
int: emY = 15;               % emission per unit of Y
int: emLimit = 80000;

% Decision variables (whole-number production units)
var 0..demand: X;            % optimal will never need exceed demand given positive costs
var 0..demand: Y;

% Constraints
constraint X + Y >= demand;
constraint emX * X + emY * Y <= emLimit;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(totalCost), "\n"
];