% Parameters
int: max_total_budget = 100;                 % Total budget limit for campaigns X and Y (dollars)
int: min_effectiveness = 150;                % Minimum required effectiveness score (points)

int: eff_per_dollar_x = 2;                   % Effectiveness contribution per dollar spent on X
int: eff_per_dollar_y = 3;                   % Effectiveness contribution per dollar spent on Y

int: cost_per_dollar_x = 20;                 % Cost per dollar allocated to X
int: cost_per_dollar_y = 30;                 % Cost per dollar allocated to Y


% Variables
var 0..max_total_budget: budget_x;           % Dollars allocated to campaign X (integer dollars)
var 0..max_total_budget: budget_y;           % Dollars allocated to campaign Y (integer dollars)

var 0..(max_total_budget * max(cost_per_dollar_x, cost_per_dollar_y)): total_cost;
                                             % Total cost in dollars (bounded)


% Constraints
% --- Budget feasibility constraints ---
constraint budget_x + budget_y <= max_total_budget;

% --- Effectiveness requirement constraints ---
constraint eff_per_dollar_x * budget_x + eff_per_dollar_y * budget_y >= min_effectiveness;

% --- Cost accounting constraints ---
constraint total_cost = cost_per_dollar_x * budget_x + cost_per_dollar_y * budget_y;


% Objective
solve minimize total_cost;