% Parameters (with values embedded)
int: max_total_resources = 5000;
int: min_X = 1000;
int: min_Y = 1500;
int: cost_X = 100;   % $ per unit in X
int: cost_Y = 75;    % $ per unit in Y

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;

% Constraints
constraint X + Y <= max_total_resources;
constraint X >= min_X;
constraint Y >= min_Y;

% Objective
var int: total_cost = cost_X * X + cost_Y * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total cost = $", show(total_cost), "\n"
];