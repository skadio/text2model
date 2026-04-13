include "globals.mzn";

% Data (embedded from description)
int: max_total_units = 100;
int: min_diff_X_minus_Y = 20;
int: max_portfolio_units = 150;

int: costX = 5000;
int: costY = 8000;

% Decision variables (integer resource units)
var 0..max_total_units: X;
var 0..max_total_units: Y;

% Constraints
constraint X + Y <= max_total_units;
constraint X - Y >= min_diff_X_minus_Y;
constraint X + 2*Y <= max_portfolio_units;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];