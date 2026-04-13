% Energy resource allocation between projects X and Y
% Data embedded as per problem statement.

include "globals.mzn";

% Decision variables (whole-number investments)
var 0..10: x;  % investment units in project X
var 0..10: y;  % investment units in project Y

% Constraints
constraint 4 * x + y <= 10;     % budget constraint
constraint x + 2 * y >= 6;      % strategic objective

% Objective: minimize total cost
var int: total_cost = 7 * x + 3 * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];