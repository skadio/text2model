% Parameters
% Total available training budget (in dollars)
int: total_budget = 100000;

% Minimum required budgets per department (in dollars)
int: min_budget_X = 30000;
int: min_budget_Y = 20000;
int: min_budget_Z = 10000;

% Cost per employee trained in each department (in dollars per employee)
% (Given in the problem statement, but not needed for the cost definition used here,
% since total_cost is defined as total spending/budget allocated.)
int: cost_per_employee_X = 5000;
int: cost_per_employee_Y = 3000;
int: cost_per_employee_Z = 2000;

% Budgets must be allocated in multiples of this unit (in dollars)
int: budget_unit = 1000;


% Variables
% Budgets allocated to each department (in dollars), restricted to overall budget bounds
var 0..total_budget: budget_X;
var 0..total_budget: budget_Y;
var 0..total_budget: budget_Z;

% Total cost/spend (in dollars)
var 0..total_budget: total_cost;


% Constraints
% Minimum budget requirements per department
constraint budget_X >= min_budget_X;
constraint budget_Y >= min_budget_Y;
constraint budget_Z >= min_budget_Z;

% Total budget must not exceed the available overall budget
constraint budget_X + budget_Y + budget_Z <= total_budget;

% Budgets must be allocated in multiples of the budget unit (e.g., $1000)
constraint budget_X mod budget_unit = 0;
constraint budget_Y mod budget_unit = 0;
constraint budget_Z mod budget_unit = 0;

% Define total cost as the sum of department budgets (total spending)
constraint total_cost = budget_X + budget_Y + budget_Z;


% Objective
solve minimize total_cost;

output [
  "budget_X = ", show(budget_X), "\n",
  "budget_Y = ", show(budget_Y), "\n",
  "budget_Z = ", show(budget_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];