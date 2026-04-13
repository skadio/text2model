% Parameters
% Minimum required total units
int: min_total_units = 100;

% Maximum allowed combined strength
int: max_strength = 600;

% Strength contribution per unit
int: strength_x = 5;
int: strength_y = 3;

% Support points (cost) per unit
int: cost_x = 5000;
int: cost_y = 3000;


% Variables
% Number of units allocated to type X and Y (whole numbers, non-negative)
var 0..(max_strength div strength_x): x_units;
var 0..(max_strength div strength_y): y_units;

% Total support points (cost), with a safe upper bound derived from variable bounds
var 0..(cost_x * (max_strength div strength_x) + cost_y * (max_strength div strength_y)): total_support_points;


% Constraints
% Minimum required total number of units
constraint x_units + y_units >= min_total_units;

% Maximum allowed combined strength (capacity/logistical limit)
constraint strength_x * x_units + strength_y * y_units <= max_strength;

% Define total support points as the linear cost of allocated units
constraint total_support_points = cost_x * x_units + cost_y * y_units;


% Objective
solve minimize total_support_points;