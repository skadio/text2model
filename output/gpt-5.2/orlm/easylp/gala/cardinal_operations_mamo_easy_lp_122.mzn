% Budget allocation between two programs X and Y (integer units)
include "globals.mzn";

% Embedded data (from problem statement)
int: totalBudgetMax = 40;

int: minX = 15;
int: minY = 10;

int: maxX = 30;
int: maxY = 20;

int: costX = 10;  % cost per unit for X
int: costY = 5;   % cost per unit for Y

% Decision variables (whole numbers)
var minX..maxX: x;
var minY..maxY: y;

% Constraints
constraint x + y <= totalBudgetMax;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];