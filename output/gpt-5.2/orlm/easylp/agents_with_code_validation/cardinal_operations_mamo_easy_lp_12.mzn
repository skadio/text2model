% Parameters
int: total_budget = 100;                 % Maximum total resources for projects X and Y
int: min_effectiveness = 50;             % Minimum required effectiveness score
int: max_diff = 30;                      % Maximum allowed absolute difference between allocations

int: eff_x = 2;                          % Effectiveness multiplier for project X
int: eff_y = 1;                          % Effectiveness multiplier for project Y

int: cost_x = 5;                         % Cost per unit allocated to project X
int: cost_y = 8;                         % Cost per unit allocated to project Y

% Variables
var 0..total_budget: x;                  % Integer units allocated to project X
var 0..total_budget: y;                  % Integer units allocated to project Y

var 0..(cost_x*total_budget + cost_y*total_budget): total_cost; % Total cost to minimize

% Constraints
% Budget constraint: total allocation cannot exceed available budget
constraint
  x + y <= total_budget;

% Effectiveness constraint: ensure minimum combined effectiveness is met
constraint
  eff_x * x + eff_y * y >= min_effectiveness;

% Balance constraint: allocations should not differ by more than max_diff
constraint
  abs(x - y) <= max_diff;

% Total cost definition: compute cost from allocations
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;