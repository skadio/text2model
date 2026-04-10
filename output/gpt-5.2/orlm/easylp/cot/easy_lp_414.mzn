% Parameters (with values embedded)
int: total_budget_cap = 5000;
int: min_diff_2x_minus_y = 1000;      % 2*X - Y >= 1000
int: max_diff_x_minus_3y = 2000;      % X - 3*Y <= 2000
int: cost_per_unit_x = 1000;
int: cost_per_unit_y = 1500;

% Variables
var 0..total_budget_cap: X;  % integer dollars allocated to channel X
var 0..total_budget_cap: Y;  % integer dollars allocated to channel Y

% Constraints
constraint X + Y <= total_budget_cap;
constraint 2 * X - Y >= min_diff_2x_minus_y;
constraint X - 3 * Y <= max_diff_x_minus_3y;

% Objective
var 0..(cost_per_unit_x * total_budget_cap + cost_per_unit_y * total_budget_cap): total_expenditure;
constraint total_expenditure = cost_per_unit_x * X + cost_per_unit_y * Y;

solve minimize total_expenditure;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum expenditure = $", show(total_expenditure), "\n"
];