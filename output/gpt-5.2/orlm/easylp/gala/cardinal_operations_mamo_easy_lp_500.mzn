% Real estate investment optimization (all data embedded)

% Decision variables: numbers of properties (must be whole numbers)
var 0..1000: X;  % residential
var 0..1000: Y;  % commercial

% Parameters (in thousand dollars)
int: costX = 200;
int: costY = 150;

% Constraints
constraint X + Y <= 1000;
constraint 3*X + 2*Y >= 2000;
constraint abs(X - Y) <= 300;

% Objective: minimize total cost (in thousand dollars)
var int: totalCostK = costX * X + costY * Y;

solve minimize totalCostK;

output [
  "X(residential) = ", show(X), "\n",
  "Y(commercial)  = ", show(Y), "\n",
  "Minimum total investment (thousand $) = ", show(totalCostK), "\n"
];