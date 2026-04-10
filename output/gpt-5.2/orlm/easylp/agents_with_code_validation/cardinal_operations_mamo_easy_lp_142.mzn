% Parameters
int: max_logistics = 50;            % Upper bound for 3*X + 2*Y
int: min_strength  = 10;            % Lower bound for X + Y
int: coeff_X_log   = 3;             % Logistics coefficient for X
int: coeff_Y_log   = 2;             % Logistics coefficient for Y
int: support_X     = 4;             % Support points per unit of X
int: support_Y     = 5;             % Support points per unit of Y

% Variables
var 0..max_logistics: x_units;      % Units allocated to X
var 0..max_logistics: y_units;      % Units allocated to Y
var 0..(support_X*max_logistics + support_Y*max_logistics): total_support;
                                    % Total support points

% Constraints
% Logistics capacity constraint: 3*X + 2*Y <= 50
constraint
  coeff_X_log * x_units + coeff_Y_log * y_units <= max_logistics;

% Minimum combined strength constraint: X + Y >= 10
constraint
  x_units + y_units >= min_strength;

% Define total support points: 4*X + 5*Y
constraint
  total_support = support_X * x_units + support_Y * y_units;

% Objective
solve minimize total_support;