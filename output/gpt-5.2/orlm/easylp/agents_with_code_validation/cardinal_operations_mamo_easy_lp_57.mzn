% Parameters
int: max_total_budget = 2000;          % Maximum combined allocation (X + Y)
int: min_extra_x = 500;               % Extra amount X must exceed half of Y by
int: cost_per_unit_x = 2;             % Unit cost for good X
int: cost_per_unit_y = 3;             % Unit cost for good Y
int: x_lb = 0;                        % Lower bound for allocation to X
int: x_ub = 1500;                     % Upper bound for allocation to X
int: y_lb = 0;                        % Lower bound for allocation to Y
int: y_ub = 1000;                     % Upper bound for allocation to Y

% Variables
var x_lb..x_ub: alloc_x;              % Integer allocation to good X
var y_lb..y_ub: alloc_y;              % Integer allocation to good Y
var 0..(cost_per_unit_x*x_ub + cost_per_unit_y*y_ub): total_cost;  % Total cost

% Constraints
% --- Budget constraint: combined allocation cannot exceed maximum budget ---
constraint
  alloc_x + alloc_y <= max_total_budget;

% --- Balance constraint: X must be at least half of Y plus an extra amount ---
% alloc_x >= alloc_y / 2 + min_extra_x  <=>  2*alloc_x >= alloc_y + 2*min_extra_x
constraint
  2 * alloc_x >= alloc_y + 2 * min_extra_x;

% --- Total cost definition: link total_cost to allocations and unit costs ---
constraint
  total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;

% (Optional) Output the optimal allocations and objective value
output [
  "alloc_x = ", show(alloc_x), "\n",
  "alloc_y = ", show(alloc_y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];