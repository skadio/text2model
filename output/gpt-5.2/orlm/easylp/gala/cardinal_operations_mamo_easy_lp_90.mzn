% Supply chain resource allocation between centers X and Y
% All data embedded as per instructions.

include "globals.mzn";

% Parameters (from problem statement)
int: total_limit = 5000;
int: cost_x = 4;
int: cost_y = 3;

% Decision variables (integer allocations)
var 0..total_limit: x;  % resources to center X
var 0..total_limit: y;  % resources to center Y

% Constraints
constraint x + y <= total_limit;      % budget/resource cap
constraint x >= 2 * y;                % X at least twice Y
constraint 2 * x + y >= 1000;         % service level requirement

% Objective: minimize total cost
var 0..(cost_x*total_limit + cost_y*total_limit): total_cost;
constraint total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];