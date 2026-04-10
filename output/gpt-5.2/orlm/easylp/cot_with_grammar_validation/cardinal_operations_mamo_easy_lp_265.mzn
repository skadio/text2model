% Parameters
int: total_budget = 100000;

int: min_X = 30000;
int: min_Y = 20000;
int: min_Z = 10000;

int: cost_per_emp_X = 5000;
int: cost_per_emp_Y = 3000;
int: cost_per_emp_Z = 2000;

int: step = 1000;

% Variables
var 0..total_budget: budget_X;
var 0..total_budget: budget_Y;
var 0..total_budget: budget_Z;

var 0..total_budget*max(cost_per_emp_X, max(cost_per_emp_Y, cost_per_emp_Z)): total_cost;

% Constraints
constraint budget_X + budget_Y + budget_Z <= total_budget;

constraint budget_X >= min_X;
constraint budget_Y >= min_Y;
constraint budget_Z >= min_Z;

constraint budget_X mod step = 0;
constraint budget_Y mod step = 0;
constraint budget_Z mod step = 0;

constraint total_cost = cost_per_emp_X * budget_X
                      + cost_per_emp_Y * budget_Y
                      + cost_per_emp_Z * budget_Z;

% Objective
solve minimize total_cost;