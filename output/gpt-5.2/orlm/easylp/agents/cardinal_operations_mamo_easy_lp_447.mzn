% Parameters
% Unit costs
int: cost_x = 4;                 % cost per unit allocated to project X
int: cost_y = 5;                 % cost per unit allocated to project Y

% Capacity / policy limits
int: max_weighted_total = 100;   % maximum for (x + 3*y)
int: min_objective_total = 50;   % minimum for (2*x + y)
int: max_diff = 20;              % maximum allowed |x - y|
int: max_x = 60;                 % upper bound on allocation to X
int: max_y = 30;                 % upper bound on allocation to Y

% Variables
var 0..max_x: x;                 % integer allocation to project X
var 0..max_y: y;                 % integer allocation to project Y
var int: total_cost;             % total cost = 4*x + 5*y

% Constraints
% Total cost definition
constraint
  total_cost = cost_x * x + cost_y * y;

% Weighted total allocation capacity: x + 3*y <= 100
constraint
  x + 3 * y <= max_weighted_total;

% Strategic minimum allocation requirement: 2*x + y >= 50
constraint
  2 * x + y >= min_objective_total;

% Difference between allocations must not exceed 20: |x - y| <= 20
constraint
  abs(x - y) <= max_diff;

% Explicit bounds (domains already enforce these)
constraint
  x <= max_x /\ y <= max_y;

% Objective
solve minimize total_cost;