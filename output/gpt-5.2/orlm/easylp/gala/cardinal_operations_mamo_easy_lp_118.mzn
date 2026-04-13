% Tourism resource allocation (integer linear optimization)
% Data embedded as requested.

int: max_total = 50;     % 2X + 3Y <= 50
int: min_combined = 10;  % X + Y >= 10
int: max_diff = 20;      % |X - Y| <= 20

int: costX = 100;
int: costY = 200;

% Decision variables (integer, nonnegative)
var 0..max_total: X;
var 0..max_total: Y;

% Constraints
constraint 2 * X + 3 * Y <= max_total;
constraint X + Y >= min_combined;
constraint abs(X - Y) <= max_diff;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];