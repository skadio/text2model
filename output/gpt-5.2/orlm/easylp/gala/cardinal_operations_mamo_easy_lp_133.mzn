% Environmental projects X and Y optimization (integer resources)
include "globals.mzn";

% Parameters (embedded from description)
int: max_total_resources = 1000;
int: x_weight = 2;     % every 2 units used in project X
int: y_weight = 3;     % every 3 units used in project Y
int: min_diff = 100;   % X at least 100 units more than Y
int: x_reduction = 5;  % $ reduction per unit in X
int: y_reduction = 7;  % $ reduction per unit in Y

% Decision variables: integer resource units allocated to each project
var 0..max_total_resources: x;
var 0..max_total_resources: y;

% Constraints
constraint x_weight * x + y_weight * y <= max_total_resources;
constraint x >= y + min_diff;

% Objective: minimize total cost (equivalently maximize total reduction)
% Since reductions are positive, minimizing "cost" here corresponds to minimizing
% the negative of the achieved reduction.
var int: total_cost = -(x_reduction * x + y_reduction * y);

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];