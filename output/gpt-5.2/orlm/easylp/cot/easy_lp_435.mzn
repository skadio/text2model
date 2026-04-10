% Parameters (with values embedded)
int: min_total_investment = 80;
int: max_diff_investment = 10;
int: max_weighted_diff = 50;

int: cost_X = 200;
int: cost_Y = 100;

% To model 0.6*X - 0.4*Y <= 50 with integers, multiply by 10:
% 6*X - 4*Y <= 500
int: wX = 6;
int: wY = 4;
int: wRHS = 500;

% Variable bounds (safe upper bounds derived from constraints)
% From X+Y>=80 and |X-Y|<=10 => each is at least 35, and minimal solutions are near 40.
% Use a generous upper bound.
int: UB = 10000;

% Variables
var 0..UB: X;
var 0..UB: Y;

% Constraints
constraint X + Y >= min_total_investment;
constraint abs(X - Y) <= max_diff_investment;
constraint wX * X - wY * Y <= wRHS;

% Objective
var int: total_cost = cost_X * X + cost_Y * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(total_cost), "\n"
];