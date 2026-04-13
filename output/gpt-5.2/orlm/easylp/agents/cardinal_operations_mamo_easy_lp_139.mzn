% Parameters
int: max_total_units = 1000;          % Maximum total number of units (X + Y)
int: min_strength = 500;              % Minimum required combined strength (2*X + 1*Y)
int: strength_x_coeff = 2;            % Strength coefficient for X in the strength constraint
int: strength_y_coeff = 1;            % Strength coefficient for Y in the strength constraint

int: support_per_x = 500;             % Support points required per unit of X
int: support_per_y = 300;             % Support points required per unit of Y

int: x_min = 0;                       % Lower bound for X allocation
int: x_max = 700;                     % Upper bound for X allocation
int: y_min = 0;                       % Lower bound for Y allocation
int: y_max = 400;                     % Upper bound for Y allocation

% Variables
var x_min..x_max: x_units;            % Number of X units allocated (integer)
var y_min..y_max: y_units;            % Number of Y units allocated (integer)

var 0..(support_per_x * x_max + support_per_y * y_max): total_support;
                                      % Total support points used (to minimize)

% Constraints
% Link total support variable to the chosen allocation of units
constraint total_support =
  support_per_x * x_units + support_per_y * y_units;

% Total number of units cannot exceed the logistics limit
constraint x_units + y_units <= max_total_units;

% Strategic strength requirement: combined strength must meet minimum
constraint strength_x_coeff * x_units + strength_y_coeff * y_units >= min_strength;

% Objective
solve minimize total_support;