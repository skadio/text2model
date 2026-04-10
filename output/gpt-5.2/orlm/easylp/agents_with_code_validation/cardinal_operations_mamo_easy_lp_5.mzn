% Parameters
int: max_total_budget = 1000;              % Maximum combined budget for channels X and Y
int: min_effectiveness = 2000;             % Minimum required effectiveness score

int: eff_per_unit_X = 2;                   % Effectiveness per unit budget for channel X
int: eff_per_unit_Y = 3;                   % Effectiveness per unit budget for channel Y

int: cost_per_unit_X = 10;                 % Cost per unit budget for channel X (dollars)
int: cost_per_unit_Y = 20;                 % Cost per unit budget for channel Y (dollars)

% Variables
var 0..max_total_budget: budget_X;         % Integer budget units allocated to channel X
var 0..max_total_budget: budget_Y;         % Integer budget units allocated to channel Y

var 0..(cost_per_unit_X*max_total_budget + cost_per_unit_Y*max_total_budget): total_cost;
                                           % Total cost in dollars (to minimize)

var 0..(eff_per_unit_X*max_total_budget + eff_per_unit_Y*max_total_budget): total_effectiveness;
                                           % Total effectiveness score

% Constraints
% Budget feasibility: combined allocation cannot exceed the maximum total budget
constraint budget_X + budget_Y <= max_total_budget;

% Define total effectiveness from channel contributions
constraint total_effectiveness = eff_per_unit_X * budget_X + eff_per_unit_Y * budget_Y;

% Campaign requirement: meet or exceed minimum effectiveness threshold
constraint total_effectiveness >= min_effectiveness;

% Define total cost from per-unit channel costs
constraint total_cost = cost_per_unit_X * budget_X + cost_per_unit_Y * budget_Y;

% Objective
solve minimize total_cost;