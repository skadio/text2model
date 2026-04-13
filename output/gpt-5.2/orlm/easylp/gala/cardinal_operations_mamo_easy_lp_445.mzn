% Resource allocation for projects X and Y (integer units), minimize total cost.

include "globals.mzn";

% Parameters (embedded from problem statement)
int: total_cap = 2000;
int: x_cap = 1500;
int: y_cap = 1000;

int: cost_x = 5;
int: cost_y = 3;

int: min_diff_2x_minus_y = 500;   % 2X - Y >= 500
int: max_diff_x_minus_2y = 1000;  % X - 2Y <= 1000

% Decision variables
var 0..x_cap: X;
var 0..y_cap: Y;

% Constraints
constraint X + Y <= total_cap;
constraint 2 * X - Y >= min_diff_2x_minus_y;
constraint X - 2 * Y <= max_diff_x_minus_2y;

% Objective
var int: total_cost = cost_x * X + cost_y * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];