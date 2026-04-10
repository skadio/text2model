% Real estate investment minimization (integer linear program)
% Data embedded as requested.

int: max_units = 1000;
int: min_diversity = 500;     % 2*X + Y >= 500
int: max_diff = 200;          % |X - Y| <= 200

int: costX = 200;
int: costY = 300;

% Decision variables: whole number of units invested in each property type
var 0..max_units: X;
var 0..max_units: Y;

% Constraints
constraint X + Y <= max_units;
constraint 2 * X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];