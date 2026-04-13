% Parameters (with values embedded)
int: max_total_tours = 50;
int: min_weighted_variety = 40;
int: max_diversity_expr = 60;

int: cost_X = 500;
int: cost_Y = 1000;

% Variables
var 0..max_total_tours: X;
var 0..max_total_tours: Y;

% Constraints
constraint X + Y <= max_total_tours;
constraint 2*X + 4*Y >= min_weighted_variety;
constraint 3*X - Y <= max_diversity_expr;

% Objective
var int: total_cost = cost_X*X + cost_Y*Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];