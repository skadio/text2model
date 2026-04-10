% Parameters
int: max_total_budget = 1000;              % Maximum combined budget for channels X and Y
int: min_effectiveness = 2000;             % Minimum required effectiveness points

int: eff_per_unit_x = 2;                   % Effectiveness points per budget unit for channel X
int: eff_per_unit_y = 3;                   % Effectiveness points per budget unit for channel Y

int: cost_per_unit_x = 10;                 % Cost ($) per budget unit for channel X
int: cost_per_unit_y = 20;                 % Cost ($) per budget unit for channel Y


% Variables
var 0..max_total_budget: budget_x;         % Budget units allocated to channel X (integer, nonnegative)
var 0..max_total_budget: budget_y;         % Budget units allocated to channel Y (integer, nonnegative)

var 0..(cost_per_unit_x*max_total_budget + cost_per_unit_y*max_total_budget): total_cost;
                                          % Total cost in dollars (bounded)


% Constraints
% Budget feasibility: total allocated budget cannot exceed the maximum available
constraint
  budget_x + budget_y <= max_total_budget;

% Campaign effectiveness requirement: ensure minimum effectiveness points are achieved
constraint
  eff_per_unit_x * budget_x + eff_per_unit_y * budget_y >= min_effectiveness;

% Cost definition: total_cost equals the sum of per-channel costs
constraint
  total_cost = cost_per_unit_x * budget_x + cost_per_unit_y * budget_y;


% Objective
solve minimize total_cost;