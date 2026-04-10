% Hospital resource allocation between services X and Y
% All parameters are embedded as requested.

include "globals.mzn";

% Parameters
int: max_total = 50;
int: min_effectiveness = 30;
int: max_balance_diff = 10;

int: cost_x = 5;
int: cost_y = 10;

% Decision variables (integers, whole units)
var 0..max_total: X;
var 0..max_total: Y;

% Constraints
constraint X + Y <= max_total;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - 2*Y) <= max_balance_diff;

% Objective: minimize total cost
var int: total_cost = cost_x*X + cost_y*Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];