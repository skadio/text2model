include "globals.mzn";

% Data (embedded as requested)
int: max_total_resources = 10000;
int: min_weighted_resources = 6000;   % 2*X + Y >= 6000
int: max_difference = 2000;           % |X - Y| <= 2000

int: costX = 5000;                    % dollars per unit for division X
int: costY = 3000;                    % dollars per unit for division Y

% Decision variables (whole-number allocations)
var 0..max_total_resources: X;
var 0..max_total_resources: Y;

% Constraints
constraint X + Y <= max_total_resources;
constraint 2 * X + Y >= min_weighted_resources;
constraint abs(X - Y) <= max_difference;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];