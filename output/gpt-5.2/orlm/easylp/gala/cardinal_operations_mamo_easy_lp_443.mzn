% Retail inventory optimization (integer quantities)

% Data (embedded as requested)
int: maxTotal = 1000;
int: xMin = 0;
int: xMax = 600;
int: yMin = 0;
int: yMax = 500;

int: costX = 5;
int: costY = 2;

% Decision variables (integer quantities)
var xMin..xMax: X;
var yMin..yMax: Y;

% Constraints
constraint X + Y <= maxTotal;
constraint X - 2 * Y >= 300;
constraint 3 * X + Y >= 500;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n"
];