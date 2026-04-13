% Parameters
int: total_budget_limit = 1000;         % Maximum allowed total budget across departments

int: min_budget_X = 300;               % Minimum required budget for department X
int: min_budget_Y = 200;               % Minimum required budget for department Y
int: min_budget_Z = 500;               % Minimum required budget for department Z

int: cost_per_unit_X = 10;             % Cost per unit invested in X
int: cost_per_unit_Y = 8;              % Cost per unit invested in Y
int: cost_per_unit_Z = 6;              % Cost per unit invested in Z

% Variables
var min_budget_X..total_budget_limit: budget_X;  % Whole-number budget allocated to department X
var min_budget_Y..total_budget_limit: budget_Y;  % Whole-number budget allocated to department Y
var min_budget_Z..total_budget_limit: budget_Z;  % Whole-number budget allocated to department Z

var 0..(cost_per_unit_X*total_budget_limit + cost_per_unit_Y*total_budget_limit + cost_per_unit_Z*total_budget_limit): total_expenditure;
% Total expenditure to minimize (bounded for solver efficiency)

% Constraints
% --- Domain and minimum budget requirements ---
constraint budget_X >= min_budget_X;
constraint budget_Y >= min_budget_Y;
constraint budget_Z >= min_budget_Z;

% --- Total budget limit across all departments ---
constraint budget_X + budget_Y + budget_Z <= total_budget_limit;

% --- Define total expenditure from per-unit costs and allocated budgets ---
constraint total_expenditure =
    cost_per_unit_X * budget_X +
    cost_per_unit_Y * budget_Y +
    cost_per_unit_Z * budget_Z;

% Objective
solve minimize total_expenditure;