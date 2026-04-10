% Parameters (with values embedded)
int: min_total_employees = 20;
int: max_resource = 40;                 % constraint: 2*X + Y <= 40
int: cost_X = 50;
int: cost_Y = 80;

% Variables
var 0..40: X;                           % employees on Project X
var 0..40: Y;                           % employees on Project Y
var 0..(cost_X*40 + cost_Y*40): total_cost;

% Constraints
constraint X + Y >= min_total_employees;
constraint 2*X + Y <= max_resource;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_daily_cost=$", show(total_cost), "\n"
];