% Transportation resource allocation optimization
% All data embedded as requested.

int: total_cap = 2000;
int: min_x = 800;
int: min_y = 500;

int: cost_x = 50;
int: cost_y = 30;

% Decision variables: whole-number allocations
var min_x..total_cap: x;   % allocation to route X
var min_y..total_cap: y;   % allocation to route Y

% Capacity constraint
constraint x + y <= total_cap;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];