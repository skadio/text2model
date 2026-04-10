% Parameters
% Budget limits (in dollars)
int: total_budget_cap = 100000;

% Minimum required budgets for each department (in dollars)
int: min_budget_X = 30000;
int: min_budget_Y = 20000;
int: min_budget_Z = 10000;

% Cost per employee trained (in dollars per $1000-budget unit)
int: cost_per_emp_X = 5000;
int: cost_per_emp_Y = 3000;
int: cost_per_emp_Z = 2000;

% Budgets must be allocated in multiples of $1000
int: budget_granularity = 1000;

% Derived bounds for integer "thousands" representation
int: cap_k  = total_budget_cap div budget_granularity;
int: minX_k = min_budget_X div budget_granularity;
int: minY_k = min_budget_Y div budget_granularity;
int: minZ_k = min_budget_Z div budget_granularity;

% Variables
% Budget allocations in units of $1000 (to enforce multiples of $1000)
var minX_k..cap_k: budgetX_k; % Department X budget in thousands of dollars
var minY_k..cap_k: budgetY_k; % Department Y budget in thousands of dollars
var minZ_k..cap_k: budgetZ_k; % Department Z budget in thousands of dollars

% Budget allocations in dollars (linked to the thousands variables)
var min_budget_X..total_budget_cap: budgetX; % Department X budget in dollars
var min_budget_Y..total_budget_cap: budgetY; % Department Y budget in dollars
var min_budget_Z..total_budget_cap: budgetZ; % Department Z budget in dollars

% Total cost (in dollars)
var 0..total_budget_cap: total_cost;

% Constraints
% --- Budget scaling / granularity linking (budgets must be multiples of $1000) ---
constraint budgetX = budgetX_k * budget_granularity;
constraint budgetY = budgetY_k * budget_granularity;
constraint budgetZ = budgetZ_k * budget_granularity;

% --- Total budget cap across all departments ---
constraint budgetX + budgetY + budgetZ <= total_budget_cap;

% --- Total cost definition (sum of per-department training costs) ---
constraint
  total_cost =
    cost_per_emp_X * budgetX_k +
    cost_per_emp_Y * budgetY_k +
    cost_per_emp_Z * budgetZ_k;

% Objective
solve minimize total_cost;