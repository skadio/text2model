% Parameters
% Total budget limit across departments (units)
int: total_budget_limit = 1000;

% Minimum required budget per department (units)
int: min_budget_x = 300;
int: min_budget_y = 200;
int: min_budget_z = 500;

% Cost per unit invested in each department (cost units per budget unit)
int: cost_per_unit_x = 10;
int: cost_per_unit_y = 8;
int: cost_per_unit_z = 6;

% Variables
% Budget allocated to each department (whole-number units)
var 0..total_budget_limit: budget_x;
var 0..total_budget_limit: budget_y;
var 0..total_budget_limit: budget_z;

% Total expenditure (upper bound: all budget spent at max unit cost)
var 0..(total_budget_limit * max([cost_per_unit_x, cost_per_unit_y, cost_per_unit_z])): total_expenditure;

% Constraints
% Minimum required budget per department
constraint budget_x >= min_budget_x;
constraint budget_y >= min_budget_y;
constraint budget_z >= min_budget_z;

% Total budget limit across all departments
constraint budget_x + budget_y + budget_z <= total_budget_limit;

% Total expenditure calculation from per-department unit costs
constraint total_expenditure =
    cost_per_unit_x * budget_x
  + cost_per_unit_y * budget_y
  + cost_per_unit_z * budget_z;

% Objective
solve minimize total_expenditure;