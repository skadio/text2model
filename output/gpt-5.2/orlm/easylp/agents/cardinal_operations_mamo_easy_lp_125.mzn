% Parameters
int: min_total_classes = 50;        % Minimum combined classes (X + Y)
int: max_diff = 20;                 % Maximum allowed excess over 2*Y (X - 2Y <= 20)
int: cost_math = 4;                 % Cost per Math class
int: cost_science = 3;              % Cost per Science class

% Variables
% Upper bounds chosen to be safe and finite based on constraints:
% From X + Y >= 50 and X <= 2Y + 20, a loose upper bound is X <= 2*(50) + 20 = 120
var 0..(max_diff + 2 * min_total_classes): X;  % Number of Math classes (integer, non-negative)
var 0..min_total_classes: Y;                   % Number of Science classes (integer, non-negative)
var 0..(cost_math*(max_diff + 2*min_total_classes) + cost_science*min_total_classes): total_cost;

% Constraints
% Minimum combined number of classes (curriculum requirement)
constraint
  X + Y >= min_total_classes;

% Limit Math relative to Science: not more than twice as many Math classes,
% and the excess over 2*Y cannot exceed max_diff
constraint
  X <= 2 * Y + max_diff;

% Define total cost from per-class costs
constraint
  total_cost = cost_math * X + cost_science * Y;

% Objective
solve minimize total_cost;

output [
  "X(Math) = ", show(X), "\n",
  "Y(Science) = ", show(Y), "\n",
  "Total cost = ", show(total_cost), "\n"
];