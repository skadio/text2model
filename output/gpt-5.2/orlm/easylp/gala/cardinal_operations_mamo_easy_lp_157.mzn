% Real estate investment optimization (integer linear program)
% Minimize total cost subject to:
%  - total properties <= 1000
%  - number of X purchased >= 3 * number of Y sold
%  - whole numbers of properties

include "globals.mzn";

% Embedded data
int: maxTotal = 1000;
int: costX = 300000;
int: costY = 200000;

% Decision variables (nonnegative integers)
var 0..maxTotal: x;  % number of type X properties purchased
var 0..maxTotal: y;  % number of type Y properties (as stated: sold)

% Constraints
constraint x + y <= maxTotal;
constraint x >= 3 * y;

% Objective: minimum total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n"
];