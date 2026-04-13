% Hospital resource allocation between two departments
% X = emergency, Y = surgery
% Minimize total resource usage (cost) while meeting effectiveness and budget constraints.

int: budget = 100;
int: min_effect = 20;

int: costX = 2;
int: costY = 3;

% Decision variables: integer allocations (units of effectiveness contributed by each department)
var 0..budget: x;
var 0..budget: y;

% Budget/resource usage constraint (total cost cannot exceed 100)
constraint costX * x + costY * y <= budget;

% Minimum effectiveness constraint (x + y at least 20)
constraint x + y >= min_effect;

% Objective: minimize total resource usage (cost)
var 0..budget: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_resource_usage = ", show(total_cost), "\n"
];