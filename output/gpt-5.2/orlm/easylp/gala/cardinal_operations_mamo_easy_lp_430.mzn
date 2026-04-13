% Transportation resource allocation: minimize cost with linear constraints
include "globals.mzn";

% Data (embedded as required)
int: max_total = 20;
int: min_demand = 10;
int: max_imbalance = 15;

int: costX = 5;
int: costY = 4;

% Decision variables (integer allocations)
var 0..max_total: x;  % resources for service X
var 0..max_total: y;  % resources for service Y

% Constraints
constraint x + y <= max_total;
constraint x + 2*y >= min_demand;
constraint 2*x - y <= max_imbalance;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];