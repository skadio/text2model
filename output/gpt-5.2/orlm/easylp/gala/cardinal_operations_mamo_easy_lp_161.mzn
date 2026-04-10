% Real estate build planning: minimize total cost
% Data embedded as requested.

int: maxUnits = 10;

int: costX = 50000;   % residential
int: costY = 75000;   % commercial

% Weighted demand constraint: 0.6*X + 0.4*Y >= 5
% Use integer scaling to avoid floats: 6*X + 4*Y >= 50
int: rhsScaled = 50;

var 0..maxUnits: X;
var 0..maxUnits: Y;

constraint X + Y <= maxUnits;
constraint 6 * X + 4 * Y >= rhsScaled;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Total units     = ", show(X + Y), "\n",
  "Total cost ($)  = ", show(totalCost), "\n"
];