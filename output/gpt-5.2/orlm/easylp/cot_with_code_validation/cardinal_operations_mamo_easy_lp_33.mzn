% Parameters (embedded data)
float: costX = 0.01;
float: costY = 0.02;

int: minX = 5000;
int: minY = 2000;
int: maxTotal = 10000;

float: rateX = 0.07;
float: rateY = 0.08;
float: minInterest = 700.0;

% Decision variables
var int: X;
var int: Y;

% Work in cents to avoid float rounding/printing issues
var int: totalCostCents;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint X + Y <= maxTotal;

constraint rateX * int2float(X) + rateY * int2float(Y) >= minInterest;

% Exact cent-cost: 0.01*X + 0.02*Y dollars = (X + 2Y) cents
constraint totalCostCents = X + 2 * Y;

% Objective (minimization)
solve minimize totalCostCents;

% Output: cost rounded to two decimal places
output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost_rounded_2dp=",
  show(totalCostCents div 100), ".",
  show((totalCostCents mod 100) div 10),
  show((totalCostCents mod 100) mod 10), "\n"
];