% Parameters (with values embedded)
int: min_total_classes = 50;
int: max_math_minus_science = 20;
int: cost_math = 4;
int: cost_science = 3;

% Variables
var 0..200: X; % Math classes
var 0..200: Y; % Science classes
var 0..(cost_math*200 + cost_science*200): total_cost;

% Constraints
constraint X + Y >= min_total_classes;
constraint X <= 2 * Y;
constraint X - Y <= max_math_minus_science;
constraint total_cost = cost_math * X + cost_science * Y;

% Objective
solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Math classes (X) = ", show(X), "\n",
  "Science classes (Y) = ", show(Y), "\n"
];