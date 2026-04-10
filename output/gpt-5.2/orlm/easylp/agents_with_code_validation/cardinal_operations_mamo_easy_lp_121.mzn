% Parameters
% Total budget upper bound (units)
int: max_total_budget = 1000;

% Minimum required effectiveness: 2*budget_X + budget_Y >= min_effectiveness
int: min_effectiveness = 500;

% Balance constraint: |budget_X - budget_Y| <= max_budget_diff
int: max_budget_diff = 200;

% Cost coefficients (dollars per unit budget allocated)
int: cost_per_unit_X = 500;
int: cost_per_unit_Y = 300;


% Variables
% Budgets allocated to campaigns X and Y (integers, non-negative)
var 0..max_total_budget: budget_X;
var 0..max_total_budget: budget_Y;

% Total cost to minimize (upper bound uses maximum possible combined cost rate)
var 0..(max_total_budget * (cost_per_unit_X + cost_per_unit_Y)): total_cost;


% Constraints
% Total budget limit across both campaigns
constraint
  budget_X + budget_Y <= max_total_budget;

% Minimum effectiveness requirement: 2*X + Y must reach the threshold
constraint
  2 * budget_X + budget_Y >= min_effectiveness;

% Balance requirement: budgets should not differ by more than the allowed amount
constraint
  abs(budget_X - budget_Y) <= max_budget_diff;

% Total cost definition from per-unit costs and allocated budgets
constraint
  total_cost = cost_per_unit_X * budget_X + cost_per_unit_Y * budget_Y;


% Objective
solve minimize total_cost;

output [
  "budget_X = ", show(budget_X), "\n",
  "budget_Y = ", show(budget_Y), "\n",
  "total_cost = ", show(total_cost), "\n"
];