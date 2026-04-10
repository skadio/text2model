% Parameters
int: total_budget = 1000;          % Max combined allocation X + Y
int: max_x = 700;                  % Max allocation for facility X
int: max_y = 500;                  % Max allocation for facility Y
int: min_diff_xy = 200;            % Minimum required difference X - Y
int: cost_x = 50;                  % Cost per unit allocated to X
int: cost_y = 30;                  % Cost per unit allocated to Y

% Variables
var 0..max_x: x;                   % Integer allocation to facility X
var 0..max_y: y;                   % Integer allocation to facility Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost (bounded)

% Constraints
% Budget limit: total allocation cannot exceed available budget
constraint x + y <= total_budget;

% Operational efficiency: 3*X - 2*Y must be nonnegative
constraint 3 * x - 2 * y >= 0;

% Balance requirement: X must exceed Y by at least the minimum difference
constraint x - y >= min_diff_xy;

% Define total cost from unit costs and allocations (keeps total_cost consistent)
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

% Output (rounded to nearest whole number is identical since integer cost)
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];