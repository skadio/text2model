include "globals.mzn";

% Data (embedded)
int: x_min = 0;
int: x_max = 10;
int: y_min = 0;
int: y_max = 8;

int: cost_x = 5;
int: cost_y = 6;

% Decision variables (integer hours)
var x_min..x_max: X;
var y_min..y_max: Y;

% Constraints
constraint 2 * X + 3 * Y >= 8;
constraint 4 * X + 1 * Y <= 16;

% Objective: minimize total cost
var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];