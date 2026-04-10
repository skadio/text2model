% Production planning ILP (integers)
include "globals.mzn";

% Data (embedded as requested)
int: capacity = 200;          % x + y <= 200
int: demand_rhs = 400;        % 3x + 2y >= 400
int: costX = 500;
int: costY = 300;

% Decision variables (whole units)
var 0..capacity: x;           % units of product X
var 0..capacity: y;           % units of product Y

% Constraints
constraint x + y <= capacity;
constraint 3 * x + 2 * y >= demand_rhs;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];