% Parameters
int: support_per_x = 1000;          % Support points required per unit X
int: support_per_y = 2000;          % Support points required per unit Y

int: min_strength = 50000;          % Minimum required combined strength
int: max_secondary = 30000;         % Maximum allowed secondary sum
int: min_diff_xy = 1000;            % Minimum required difference X - Y

int: strength_coef_x = 5;           % Strength coefficient for X in first constraint
int: strength_coef_y = 10;          % Strength coefficient for Y in first constraint

int: secondary_coef_x = 3;          % Coefficient for X in second constraint
int: secondary_coef_y = 4;          % Coefficient for Y in second constraint

% Variable upper bounds derived from constraints to ensure bounded domains
% From 3X + 4Y <= 30000 => X <= 10000 and Y <= 7500 (when the other is 0)
int: x_ub = 10000;                  % Upper bound for units of X
int: y_ub = 7500;                   % Upper bound for units of Y


% Variables
var 0..x_ub: x_units;               % Number of unit X (non-negative integer)
var 0..y_ub: y_units;               % Number of unit Y (non-negative integer)

var 0..(support_per_x * x_ub + support_per_y * y_ub): total_support;
                                    % Total support points used (objective)


% Constraints
% Link total support to chosen quantities of units
constraint
  total_support = support_per_x * x_units + support_per_y * y_units;

% Minimum combined strength requirement
constraint
  strength_coef_x * x_units + strength_coef_y * y_units >= min_strength;

% Maximum allowed secondary sum (logistical/operational limit)
constraint
  secondary_coef_x * x_units + secondary_coef_y * y_units <= max_secondary;

% Minimum required difference between unit counts (X - Y)
constraint
  x_units - y_units >= min_diff_xy;


% Objective
solve minimize total_support;