% Extra classes planning: minimize total cost with integer class counts

% Decision variables (integers, nonnegative)
var 0..1000: X;  % Math classes
var 0..1000: Y;  % Science classes

% Parameters (embedded from description)
int: min_total_classes = 50;
int: max_diff = 20;
int: cost_math = 4;
int: cost_science = 3;

% Constraints
constraint X + Y >= min_total_classes;
constraint X <= 2 * Y;
constraint X - Y <= max_diff;

% Objective
var int: total_cost = cost_math * X + cost_science * Y;
solve minimize total_cost;

% Output: minimum total cost (already integer, hence "rounded")
output [
  "X (Math classes) = ", show(X), "\n",
  "Y (Science classes) = ", show(Y), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];