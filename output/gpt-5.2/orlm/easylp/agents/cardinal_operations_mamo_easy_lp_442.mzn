% Parameters
% All data is embedded directly in the model as requested.
int: total_budget_limit = 1000;          % Maximum combined budget for X and Y
int: min_effectiveness = 500;            % Minimum required effectiveness score
int: max_budget_difference = 300;        % Maximum allowed absolute difference |X - Y|

int: eff_weight_x = 2;                   % Effectiveness contribution coefficient for X
int: eff_weight_y = 1;                   % Effectiveness contribution coefficient for Y

int: cost_per_unit_x = 5;                % Cost per dollar budget allocated to X
int: cost_per_unit_y = 3;                % Cost per dollar budget allocated to Y

% Variables
var 0..total_budget_limit: budget_x;     % Budget allocated to department X (whole dollars)
var 0..total_budget_limit: budget_y;     % Budget allocated to department Y (whole dollars)

var 0..(cost_per_unit_x*total_budget_limit + cost_per_unit_y*total_budget_limit): total_cost;
                                         % Total cost (dollars)

% Helper variable for absolute difference between budgets
var 0..total_budget_limit: budget_diff;  % |budget_x - budget_y|

% Constraints
% --- Total budget limit ---
constraint budget_x + budget_y <= total_budget_limit;

% --- Minimum effectiveness requirement ---
constraint eff_weight_x * budget_x + eff_weight_y * budget_y >= min_effectiveness;

% --- Absolute difference between budgets (link helper variable) ---
constraint budget_diff = abs(budget_x - budget_y);

% --- Maximum allowed discrepancy in budgets ---
constraint budget_diff <= max_budget_difference;

% --- Total cost calculation ---
constraint total_cost = cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;

% Objective
solve minimize total_cost;