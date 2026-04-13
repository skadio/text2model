% Parameters
int: max_total_budget = 5000;                 % Maximum combined budget for channels X and Y (dollars)
int: min_effectiveness = 12000;               % Minimum required effectiveness score
int: max_balance_score = 10000;               % Maximum allowed balance score (5*X - 2*Y)

int: eff_coeff_x = 3;                         % Effectiveness coefficient for channel X
int: eff_coeff_y = 4;                         % Effectiveness coefficient for channel Y

int: balance_coeff_x = 5;                     % Balance constraint coefficient for channel X
int: balance_coeff_y = 2;                     % Balance constraint coefficient for channel Y (subtracted)

int: cost_x = 200;                            % Cost per budget dollar allocated to channel X
int: cost_y = 150;                            % Cost per budget dollar allocated to channel Y

% Variables
var 0..max_total_budget: budget_x;             % Budget allocated to channel X (whole dollars)
var 0..max_total_budget: budget_y;             % Budget allocated to channel Y (whole dollars)

var 0..(cost_x*max_total_budget + cost_y*max_total_budget): total_cost; % Total cost to minimize

% Constraints
% Link total_cost to the chosen budgets (cost accounting)
constraint
  total_cost = cost_x * budget_x + cost_y * budget_y;

% Total budget limit across both channels
constraint
  budget_x + budget_y <= max_total_budget;

% Minimum campaign effectiveness requirement
constraint
  eff_coeff_x * budget_x + eff_coeff_y * budget_y >= min_effectiveness;

% Balance/design constraint: 5*X - 2*Y must not exceed the allowed maximum
constraint
  balance_coeff_x * budget_x - balance_coeff_y * budget_y <= max_balance_score;

% Objective
solve minimize total_cost;