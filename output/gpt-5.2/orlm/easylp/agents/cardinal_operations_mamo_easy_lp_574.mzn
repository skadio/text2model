% Parameters
% Operating cost per truck on each route
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;

% Capacity/service constraints
int: max_x1_x2 = 2000;     % X1 + X2 <= 2000
int: min_x2_x3 = 1000;     % X2 + X3 >= 1000
int: eq_rhs    = 500;      % X1 - 2*X3 == 500

% Upper bounds per route
int: ub_x1 = 1500;
int: ub_x2 = 1200;
int: ub_x3 = 800;

% Variables
var 0..ub_x1: x1;          % trucks assigned to Route X1
var 0..ub_x2: x2;          % trucks assigned to Route X2
var 0..ub_x3: x3;          % trucks assigned to Route X3

var int: total_cost;       % total operating cost (minimized)

% Constraints
% Compute total operating cost from route allocations
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Capacity limit
constraint
  x1 + x2 <= max_x1_x2;

% Service requirement
constraint
  x2 + x3 >= min_x2_x3;

% Strategic equality requirement
constraint
  x1 - 2 * x3 = eq_rhs;

% Objective
solve minimize total_cost;