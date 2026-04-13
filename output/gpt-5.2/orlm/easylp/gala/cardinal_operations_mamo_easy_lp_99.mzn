% Hiring optimization for positions X and Y

% Data (embedded as requested)
int: maxHires = 50;
int: costX = 5000;
int: costY = 8000;

% Decision variables
var 0..maxHires: X;   % number hired for position X
var 0..maxHires: Y;   % number hired for position Y

% Constraints
constraint X + Y <= maxHires;

% "X must be at least three times the number of those not hired for position Y
% (considering the total hires allowed)"
% Not hired for Y out of the 50-hire allowance is (maxHires - Y)
constraint X >= 3 * (maxHires - Y);

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n"
];