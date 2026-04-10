% Parameters
int: total_budget_limit = 10000;              % Maximum combined budget for projects X and Y (in dollars)
int: impact_min_required = 40000;             % Minimum required combined mission impact score (points)

int: mission_coeff_X = 10;                    % Coefficient for X in mission impact score (points per dollar)
int: mission_coeff_Y = 4;                     % Coefficient for Y in mission impact score (points per dollar)

int: cost_per_dollar_X = 50;                  % Cost per dollar allocated to X (dollars/objective units per dollar)
int: cost_per_dollar_Y = 30;                  % Cost per dollar allocated to Y (dollars/objective units per dollar)

% Variables
var 0..total_budget_limit: budget_X;          % Integer budget allocated to project X (dollars)
var 0..total_budget_limit: budget_Y;          % Integer budget allocated to project Y (dollars)

var 0..(cost_per_dollar_X*total_budget_limit + cost_per_dollar_Y*total_budget_limit): total_cost;
                                              % Total cost to minimize (dollars)

% Constraints
% Budget limit: combined allocation cannot exceed the available total budget
constraint budget_X + budget_Y <= total_budget_limit;

% Mission impact requirement: ensure minimum combined impact score is achieved
constraint mission_coeff_X * budget_X + mission_coeff_Y * budget_Y >= impact_min_required;

% Total cost definition: link total_cost to the allocated budgets and per-dollar costs
constraint total_cost = cost_per_dollar_X * budget_X + cost_per_dollar_Y * budget_Y;

% Objective
solve minimize total_cost;