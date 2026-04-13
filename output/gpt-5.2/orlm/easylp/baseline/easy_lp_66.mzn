% Resource allocation between projects X and Y (integers)
% Minimize total cost subject to constraints, with all data embedded.

int: min_total_resources = 100;
int: coeff_x = 5;
int: coeff_y = -2;
int: max_linear = 50;

int: cost_x = 10;
int: cost_y = 20;

% Variable bounds (safe upper bounds derived from constraints)
% From X + Y >= 100 and 5X - 2Y <= 50 with Y >= 0:
% 5X - 2(100 - X) <= 50 => 7X <= 250 => X <= 35
% Then Y can be at most 100 when X=0 in the minimum-sum solution, but allow more safely.
var 0..35: X;
var 0..200: Y;

constraint X + Y >= min_total_resources;
constraint coeff_x * X + coeff_y * Y <= max_linear;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];