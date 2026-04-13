% Parameters
% Minimum total resource requirement
int: min_total_resources = 100;

% Constraint coefficients for (5*X - 2*Y <= 50)
int: coef_x = 5;
int: coef_y = -2;
int: rhs_limit = 50;

% Unit costs in dollars
int: cost_x = 10;
int: cost_y = 20;

% Safe upper bounds for allocations (derived from constraints)
int: X_ub = 50;
int: Y_ub = 250;

% Variables
% Resource allocations (integers, nonnegative, bounded)
var 0..X_ub: x;   % resources allocated to project X
var 0..Y_ub: y;   % resources allocated to project Y

% Total cost in dollars (bounded by max possible within variable bounds)
var 0..(cost_x * X_ub + cost_y * Y_ub): total_cost;

% Constraints
% Minimum total resource requirement across both projects
constraint
  x + y >= min_total_resources;

% Company resource distribution strategy: 5*X - 2*Y must not exceed the limit
constraint
  coef_x * x + coef_y * y <= rhs_limit;

% Define total cost from unit costs and allocations
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;