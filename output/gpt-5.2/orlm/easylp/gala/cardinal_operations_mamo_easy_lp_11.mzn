include "globals.mzn";

% Data (embedded)
int: min_output = 12;      % 4x + 6y >= 12
int: max_consumption = 15; % 3x + 5y <= 15
int: cost_x = 7;
int: cost_y = 10;

% Decision variables (nonnegative integers)
var 0..max_consumption: x;
var 0..max_consumption: y;

% Constraints
constraint 4*x + 6*y >= min_output;
constraint 3*x + 5*y <= max_consumption;

% Objective
var int: total_cost = cost_x*x + cost_y*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];