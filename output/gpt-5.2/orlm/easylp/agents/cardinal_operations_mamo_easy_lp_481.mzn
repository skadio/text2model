% Parameters
int: total_resources_limit = 500;      % Maximum combined resources for initiatives X and Y
int: min_difference_XY     = 100;      % X must be at least this many units more than Y
int: max_resources_X       = 350;      % Upper bound on resources allocated to X
int: cost_per_unit_X       = 20;       % Cost per unit allocated to X
int: cost_per_unit_Y       = 10;       % Cost per unit allocated to Y

% Variables
var 0..max_resources_X: x;             % Integer units allocated to initiative X
var 0..total_resources_limit: y;       % Integer units allocated to initiative Y
var 0..(cost_per_unit_X*max_resources_X + cost_per_unit_Y*total_resources_limit): total_cost;
                                       % Total cost (bounded for safe linear use)

% Constraints
% Budget/resource limit: combined allocation cannot exceed the available resources
constraint
  x + y <= total_resources_limit;

% Minimum difference requirement: X must have at least min_difference_XY more units than Y
constraint
  x - y >= min_difference_XY;

% Define total cost based on per-unit costs (linear cost calculation)
constraint
  total_cost = cost_per_unit_X * x + cost_per_unit_Y * y;

% Objective
solve minimize total_cost;