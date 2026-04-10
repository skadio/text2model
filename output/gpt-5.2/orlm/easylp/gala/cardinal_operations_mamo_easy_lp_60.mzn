% Telecommunications resource allocation: minimize cost subject to constraints

% Data (embedded)
int: costX = 2000;
int: costY = 3000;

int: perfX = 5;
int: perfY = 10;
int: minPerf = 50;

int: usageX = 3;
int: usageY = 4;
int: maxUsage = 40;

% Decision variables (integer number of resource units)
var 0..maxUsage: X;
var 0..maxUsage: Y;

% Constraints
constraint perfX * X + perfY * Y >= minPerf;
constraint usageX * X + usageY * Y <= maxUsage;

% Objective: minimize total cost in dollars
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum cost ($) = ", show(totalCost), "\n"
];