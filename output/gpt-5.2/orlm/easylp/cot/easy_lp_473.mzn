% Parameters (with values embedded)
int: budget_max = 200;
int: min_effectiveness = 150;
int: max_diff = 50;
int: cost_X = 50;
int: cost_Y = 80;

% Variables
var 0..budget_max: X;
var 0..budget_max: Y;
var int: total_cost;

% Constraints
constraint X + Y <= budget_max;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];