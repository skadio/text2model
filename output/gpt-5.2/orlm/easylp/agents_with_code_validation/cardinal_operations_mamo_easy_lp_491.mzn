% Parameters
int: support_per_X = 1000;              % Support points required per unit X
int: support_per_Y = 2000;              % Support points required per unit Y

int: strength_coeff_X = 5;              % Coefficient for X in combined strength constraint
int: strength_coeff_Y = 10;             % Coefficient for Y in combined strength constraint
int: min_strength = 50000;              % Minimum required combined strength

int: limit_coeff_X = 3;                 % Coefficient for X in upper-bound sum constraint
int: limit_coeff_Y = 4;                 % Coefficient for Y in upper-bound sum constraint
int: max_limit_sum = 30000;             % Maximum allowed sum in the upper-bound constraint

int: min_diff_X_minus_Y = 1000;         % Minimum allowed difference X - Y

% Derived safe upper bounds for decision variables (for bounded declarations)
% From 3*X + 4*Y <= 30000, we have X <= 10000 and Y <= 7500 when the other is 0.
int: max_X = max_limit_sum div limit_coeff_X;   % 10000
int: max_Y = max_limit_sum div limit_coeff_Y;   % 7500


% Variables
var 0..max_X: units_X;                  % Number of units of type X (integer, bounded)
var 0..max_Y: units_Y;                  % Number of units of type Y (integer, bounded)

var 0..(support_per_X*max_X + support_per_Y*max_Y): total_support_points;
                                        % Total support points used (objective-related)


% Constraints
% Total support points definition
constraint
  total_support_points = support_per_X * units_X + support_per_Y * units_Y;

% Minimum combined strength requirement: 5*X + 10*Y >= 50000
constraint
  strength_coeff_X * units_X + strength_coeff_Y * units_Y >= min_strength;

% Upper-bound logistical/limit constraint: 3*X + 4*Y <= 30000
constraint
  limit_coeff_X * units_X + limit_coeff_Y * units_Y <= max_limit_sum;

% Minimum difference between unit counts: X - Y >= 1000
constraint
  units_X - units_Y >= min_diff_X_minus_Y;


% Objective
solve minimize total_support_points;