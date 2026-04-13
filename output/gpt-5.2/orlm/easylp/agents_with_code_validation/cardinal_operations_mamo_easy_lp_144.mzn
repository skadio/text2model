% Parameters
int: support_X = 5000;              % Support points required per unit of X
int: support_Y = 3000;              % Support points required per unit of Y
int: min_total_units = 50;          % Minimum total number of units required
int: strength_coeff_X = 5;          % Strength coefficient for X
int: strength_coeff_Y = 3;          % Strength coefficient for Y
int: max_strength = 200;            % Maximum allowed combined strength

% Variables
var 0..(max_strength div strength_coeff_X): x_units;   % Number of X units (non-negative integer)
var 0..(max_strength div strength_coeff_Y): y_units;   % Number of Y units (non-negative integer)
var int: total_support;                                 % Total support points (objective)

% Constraints
% Minimum total number of units required
constraint x_units + y_units >= min_total_units;

% Maximum allowed combined strength (logistics limitation)
constraint strength_coeff_X * x_units + strength_coeff_Y * y_units <= max_strength;

% Define objective expression
constraint total_support = support_X * x_units + support_Y * y_units;

% Objective
solve minimize total_support;