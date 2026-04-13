% Parameters
int: max_total_budget = 1000;              % Maximum combined budget for campaigns X and Y
int: min_effectiveness = 500;              % Minimum required effectiveness score
int: max_budget_difference = 200;          % Maximum allowed absolute difference |X - Y|

int: eff_per_unit_X = 2;                   % Effectiveness contribution per unit of budget for X
int: eff_per_unit_Y = 1;                   % Effectiveness contribution per unit of budget for Y

int: cost_per_unit_X = 500;                % Cost per unit budget for campaign X (in dollars)
int: cost_per_unit_Y = 300;                % Cost per unit budget for campaign Y (in dollars)

% Variables
var 0..max_total_budget: budget_X;         % Budget allocated to campaign X (integer, non-negative)
var 0..max_total_budget: budget_Y;         % Budget allocated to campaign Y (integer, non-negative)

% Upper bound is conservative: all budget could be allocated to either campaign
var 0..(cost_per_unit_X*max_total_budget + cost_per_unit_Y*max_total_budget): total_cost;
                                           % Total cost in dollars

% Constraints
% Budget feasibility: combined budget cannot exceed the maximum available
constraint budget_X + budget_Y <= max_total_budget;

% Reach/frequency requirement: minimum effectiveness must be achieved
constraint eff_per_unit_X * budget_X + eff_per_unit_Y * budget_Y >= min_effectiveness;

% Balance requirement: budgets for X and Y must not differ by more than the allowed bound
constraint abs(budget_X - budget_Y) <= max_budget_difference;

% Total cost definition: link total_cost to the chosen budgets and per-unit costs
constraint total_cost = cost_per_unit_X * budget_X + cost_per_unit_Y * budget_Y;

% Objective
solve minimize total_cost;