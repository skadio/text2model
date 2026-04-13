% Parameters
% Minimum total number of units required
int: min_total_units = 100;

% Maximum allowed combined strength (5*X + 3*Y)
int: max_strength = 600;

% Strength contribution per unit type
int: strength_X = 5;
int: strength_Y = 3;

% Support points (cost) per unit type (in dollars)
int: cost_X = 5000;
int: cost_Y = 3000;

% Variables
% Number of units of type X and Y (must be whole numbers and non-negative)
var 0..(max_strength div strength_X): x_units;
var 0..(max_strength div strength_Y): y_units;

% Total support points to minimize (upper bound from max possible units in each type)
var 0..(cost_X * (max_strength div strength_X) + cost_Y * (max_strength div strength_Y)): total_support_points;

% Constraints
% Link total support points to chosen numbers of units
constraint total_support_points = cost_X * x_units + cost_Y * y_units;

% Ensure at least the minimum total number of units is allocated
constraint x_units + y_units >= min_total_units;

% Enforce the maximum combined strength limit
constraint strength_X * x_units + strength_Y * y_units <= max_strength;

% Objective
solve minimize total_support_points;