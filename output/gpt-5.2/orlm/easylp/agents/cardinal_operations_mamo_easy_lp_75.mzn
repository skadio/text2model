% Parameters
int: max_projects = 15;                 % Maximum total number of projects supported
int: min_strength = 10;                 % Minimum required combined strength

int: strength_X_coeff = 2;              % Strength coefficient for project X
int: strength_Y_coeff = 3;              % Strength coefficient for project Y

int: support_per_X = 5;                 % Support points required per unit of X
int: support_per_Y = 3;                 % Support points required per unit of Y

% Variables
var 0..max_projects: X;                 % Integer number of units of project X
var 0..max_projects: Y;                 % Integer number of units of project Y

var 0..(support_per_X * max_projects + support_per_Y * max_projects): total_support;
                                        % Total support points to minimize

% Constraints
% Total projects limit (logistical constraint)
constraint
  X + Y <= max_projects;

% Minimum combined strength requirement
constraint
  strength_X_coeff * X + strength_Y_coeff * Y >= min_strength;

% Define total support points based on chosen project units
constraint
  total_support = support_per_X * X + support_per_Y * Y;

% Objective
solve minimize total_support;