% Parameters
int: total_resource_cap = 2000;          % Max combined allocation for X and Y
int: min_diff_2x_minus_y = 500;          % Minimum for (2*X - Y)
int: max_diff_x_minus_2y = 1000;         % Maximum for (X - 2*Y)
int: max_x = 1500;                       % Upper bound for allocation to Project X
int: max_y = 1000;                       % Upper bound for allocation to Project Y
int: cost_x = 5;                         % Cost per unit for Project X
int: cost_y = 3;                         % Cost per unit for Project Y

% Variables
var 0..max_x: x;                         % Integer units allocated to Project X
var 0..max_y: y;                         % Integer units allocated to Project Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost to minimize

% Constraints
% Resource capacity: combined allocation cannot exceed the total cap
constraint x + y <= total_resource_cap;

% Balance constraint 1: (2*X - Y) must be at least the required minimum difference
constraint 2 * x - y >= min_diff_2x_minus_y;

% Balance constraint 2: (X - 2*Y) must not exceed the allowed maximum difference
constraint x - 2 * y <= max_diff_x_minus_2y;

% Total cost definition (links cost variable to decision variables)
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];