% Parameters (with values embedded)
int: total_budget_max = 200;
int: min_x = 50;
int: min_y = 30;
int: cost_x = 5000;   % dollars per unit for Department X
int: cost_y = 8000;   % dollars per unit for Department Y

% Variables
var min_x..total_budget_max: x;  % units allocated to Department X
var min_y..total_budget_max: y;  % units allocated to Department Y
var 0..(total_budget_max * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x + y <= total_budget_max;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

output [
  "x_units=", show(x), "\n",
  "y_units=", show(y), "\n",
  "min_total_expenditure_dollars=", show(total_cost), "\n"
];