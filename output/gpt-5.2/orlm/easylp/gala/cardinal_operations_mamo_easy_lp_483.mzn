include "globals.mzn";

% Decision variables: integer allocations to projects X and Y
var 0..100: x;
var 0..100: y;

% Constraints
constraint 4*x + 5*y <= 100;                 % budget limitation
constraint x + y >= 20;                      % minimum combined allocation
constraint abs(2*x - y) <= 30;               % balance constraint

% Objective: minimize total cost
var int: total_cost = 6*x + 2*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];