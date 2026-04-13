% Parameters (with values embedded)
int: cap_limit = 500;
int: min_trucks = 100;
int: max_diff = 50;

int: cost_X = 4;
int: cost_Y = 6;

% Variables
var 0..cap_limit: x; % trucks on route X (bounded by capacity constraint)
var 0..cap_limit: y; % trucks on route Y (bounded by capacity constraint)

% Constraints
constraint 2 * x + 3 * y <= cap_limit;
constraint x + y >= min_trucks;
constraint abs(x - y) <= max_diff;

% Objective
solve minimize cost_X * x + cost_Y * y;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_cost=", show(cost_X * x + cost_Y * y), "\n",
  "rounded_min_cost=", show(round(int2float(cost_X * x + cost_Y * y))), "\n"
];