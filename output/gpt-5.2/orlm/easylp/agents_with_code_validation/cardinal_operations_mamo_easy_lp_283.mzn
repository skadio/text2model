% Parameters
int: max_total_budget = 50;          % Maximum total budget across all campaigns (units)
int: min_budget_X = 10;              % Minimum budget for campaign X (units)
int: min_budget_Y = 15;              % Minimum budget for campaign Y (units)
int: min_budget_Z = 5;               % Minimum budget for campaign Z (units)

int: cost_per_unit_X = 500;          % Cost per unit invested in campaign X (dollars/unit)
int: cost_per_unit_Y = 400;          % Cost per unit invested in campaign Y (dollars/unit)
int: cost_per_unit_Z = 300;          % Cost per unit invested in campaign Z (dollars/unit)

% Variables
var min_budget_X..max_total_budget: budget_X;   % Units allocated to campaign X
var min_budget_Y..max_total_budget: budget_Y;   % Units allocated to campaign Y
var min_budget_Z..max_total_budget: budget_Z;   % Units allocated to campaign Z

% Upper bound is a safe linear bound: at most max_total_budget units at the max unit cost
var 0..(max_total_budget * max([cost_per_unit_X, cost_per_unit_Y, cost_per_unit_Z])): total_cost;
                                                % Total investment cost (dollars)

% Constraints
% Budget feasibility: total allocated units across campaigns cannot exceed the maximum available
constraint budget_X + budget_Y + budget_Z <= max_total_budget;

% Cost accounting: total_cost equals the weighted sum of unit allocations and their per-unit costs
constraint total_cost =
    cost_per_unit_X * budget_X +
    cost_per_unit_Y * budget_Y +
    cost_per_unit_Z * budget_Z;

% Objective
solve minimize total_cost;