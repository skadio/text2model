% Parameters
% Support points required per unit
int: support_per_x = 5000;
int: support_per_y = 3000;

% Minimum total units required
int: min_total_units = 50;

% Strength coefficients and limit
int: strength_coef_x = 5;
int: strength_coef_y = 3;
int: max_strength = 200;

% Variables
% Number of units of type X and Y (non-negative integers), bounded by strength limit
var 0..max_strength div strength_coef_x: x_units;
var 0..max_strength div strength_coef_y: y_units;

% Total support points to minimize (bounded by max possible units under strength limit)
var 0..(support_per_x * (max_strength div strength_coef_x)
      + support_per_y * (max_strength div strength_coef_y)): total_support;

% Constraints
% Link total_support to the chosen numbers of units
constraint
  total_support = support_per_x * x_units + support_per_y * y_units;

% Enforce minimum total number of units (operational requirement)
constraint
  x_units + y_units >= min_total_units;

% Enforce maximum combined strength due to logistics limitations
constraint
  strength_coef_x * x_units + strength_coef_y * y_units <= max_strength;

% Objective
solve minimize total_support;