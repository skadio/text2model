% Parameters
int: total_resource_cap = 200;                 % Maximum total resources available
int: min_combined_requirement = 100;           % Minimum requirement for 2*X + Y
int: max_difference = 50;                      % Maximum allowed absolute difference |X - Y|

int: max_x = 150;                              % Upper bound for allocation to project X
int: max_y = 100;                              % Upper bound for allocation to project Y

int: cost_per_unit_x = 5000;                   % Cost per unit allocated to project X
int: cost_per_unit_y = 3000;                   % Cost per unit allocated to project Y

% Variables
var 0..max_x: x_units;                         % Integer units allocated to project X
var 0..max_y: y_units;                         % Integer units allocated to project Y

var 0..(cost_per_unit_x*max_x + cost_per_unit_y*max_y): total_cost;  % Total cost in dollars

% Constraints
% Link total_cost to the allocations and per-unit costs
constraint
  total_cost = cost_per_unit_x * x_units + cost_per_unit_y * y_units;

% Total resource cap: combined allocation cannot exceed the budgeted limit
constraint
  x_units + y_units <= total_resource_cap;

% Minimum combined requirement: 2*X + Y must meet or exceed the stated threshold
constraint
  2 * x_units + y_units >= min_combined_requirement;

% Workload balance: absolute difference between allocations cannot exceed max_difference
constraint
  abs(x_units - y_units) <= max_difference;

% Objective
solve minimize total_cost;