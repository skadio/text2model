% Parameters
int: max_hires = 50;                 % Maximum total hires allowed (X + Y)
int: cost_X = 5000;                  % Cost per hire for position X (dollars)
int: cost_Y = 8000;                  % Cost per hire for position Y (dollars)
int: multiplier = 3;                 % X must be at least 3 times "not hired for Y"

% Variables
var 0..max_hires: X;                 % Number of employees hired for position X
var 0..max_hires: Y;                 % Number of employees hired for position Y
var 0..(cost_X*max_hires + cost_Y*max_hires): total_cost;  % Total cost (dollars)

% Constraints
% Total hires cannot exceed the budgeted maximum
constraint
  X + Y <= max_hires;

% Total cost definition
constraint
  total_cost = cost_X * X + cost_Y * Y;

% Critical staffing rule:
% X must be at least multiplier times the unused capacity with respect to Y (max_hires - Y)
constraint
  X >= multiplier * (max_hires - Y);

% Objective
solve minimize total_cost;