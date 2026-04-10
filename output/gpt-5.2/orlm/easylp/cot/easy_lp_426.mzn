% Parameters (with values embedded)
int: costX = 50;
int: costY = 75;
int: maxTotalUnits = 1200;
int: minGapXY = 300;          % X must be at least 300 more than Y
int: storageLimit = 2000;     % 2*X + Y <= storageLimit

% Variables
var 0..maxTotalUnits: X;      % units of product X
var 0..maxTotalUnits: Y;      % units of product Y

% Constraints
constraint X + Y <= maxTotalUnits;
constraint X - Y >= minGapXY;
constraint 2*X + Y <= storageLimit;

% Objective
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(totalCost), "\n"
];