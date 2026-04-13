% Shipping fleet mix optimization (all data embedded)

include "globals.mzn";

% Decision variables: number of vessels of each type (integers)
var 0..100: x;  % type X
var 0..100: y;  % type Y

% Constraints
constraint x + y <= 100;              % port capacity
constraint 2*x + 3*y >= 50;           % service level (operational capacity)
constraint abs(x - y) <= 20;          % balanced fleet composition

% Objective: minimize daily operating cost
var int: cost = 3*x + 2*y;
solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(cost), "\n"
];