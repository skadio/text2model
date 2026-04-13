% Parameters
% Total budget limit (dollars)
int: max_budget = 100;

% Minimum required effectiveness
int: min_effectiveness = 150;

% Effectiveness per dollar spent on each campaign
int: eff_per_dollar_X = 2;
int: eff_per_dollar_Y = 3;

% Cost per dollar spent on each campaign (dollars)
int: cost_per_dollar_X = 20;
int: cost_per_dollar_Y = 30;


% Variables
% Budget allocated to campaign X (whole dollars)
var 0..max_budget: budget_X;

% Budget allocated to campaign Y (whole dollars)
var 0..max_budget: budget_Y;

% Total cost (dollars), bounded using max possible spend and costs
var 0..(max_budget * max(cost_per_dollar_X, cost_per_dollar_Y)): total_cost;

% Total effectiveness score, bounded by max possible spend and effectiveness
var 0..(max_budget * max(eff_per_dollar_X, eff_per_dollar_Y)): total_effectiveness;


% Constraints
%--- Budget feasibility: total allocated budget cannot exceed the limit
constraint
  budget_X + budget_Y <= max_budget;

%--- Effectiveness requirement: combined effectiveness must reach the minimum
constraint
  total_effectiveness = eff_per_dollar_X * budget_X + eff_per_dollar_Y * budget_Y;

constraint
  total_effectiveness >= min_effectiveness;

%--- Cost accounting: total cost induced by the allocated budgets
constraint
  total_cost = cost_per_dollar_X * budget_X + cost_per_dollar_Y * budget_Y;


% Objective
solve minimize total_cost;