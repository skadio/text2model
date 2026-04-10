% Parameters
int: total_allocation_max = 1000;     % Budget cap for combined allocation
int: max_x = 700;                     % Maximum allocation for facility X
int: max_y = 500;                     % Maximum allocation for facility Y
int: min_diff_xy = 200;               % Minimum required difference X - Y

int: cost_x = 50;                     % Cost per unit allocated to X
int: cost_y = 30;                     % Cost per unit allocated to Y

% Variables
var 0..max_x: x;                      % Integer allocation to facility X
var 0..max_y: y;                      % Integer allocation to facility Y

var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost to minimize

% Constraints
% Link total_cost to allocations and unit costs
constraint
  total_cost = cost_x * x + cost_y * y;

% Budget cap: combined allocation cannot exceed total_allocation_max
constraint
  x + y <= total_allocation_max;

% Operational efficiency: 3*x - 2*y must be at least 0
constraint
  3 * x - 2 * y >= 0;

% Balanced distribution: difference between allocations must be at least min_diff_xy (X - Y)
constraint
  x - y >= min_diff_xy;

% Objective
solve minimize total_cost;