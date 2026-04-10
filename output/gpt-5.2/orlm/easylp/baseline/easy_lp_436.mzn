% Budget allocation between two departments X and Y

% Decision variables: integer units allocated
var int: x_units;
var int: y_units;

% Parameters (all embedded)
int: min_budget_x = 200;
int: min_budget_y = 100;
int: max_total_budget = 1000;

int: cost_per_unit_x = 50;
int: cost_per_unit_y = 80;

% Budgets implied by units
var int: budget_x = cost_per_unit_x * x_units;
var int: budget_y = cost_per_unit_y * y_units;

% Constraints
constraint x_units >= 0 /\ y_units >= 0;
constraint budget_x >= min_budget_x;
constraint budget_y >= min_budget_y;
constraint budget_x + budget_y <= max_total_budget;

% Objective: minimize total cost (equals total allocated budget)
var int: total_cost = budget_x + budget_y;
solve minimize total_cost;

output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "budget_x=", show(budget_x), "\n",
  "budget_y=", show(budget_y), "\n",
  "minimal_total_cost=", show(total_cost), "\n"
];