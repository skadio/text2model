% Parameters
int: max_units = 10000;                 % Upper bound on total units X + Y
int: min_strength = 7000;               % Minimum required strength: 2*X + Y >= min_strength
int: max_imbalance = 2000;              % Maximum allowed imbalance: X - 2*Y <= max_imbalance
int: support_per_x = 5000;              % Support points required per unit of X
int: support_per_y = 3000;              % Support points required per unit of Y

% Variables
var 0..max_units: x_units;              % Number of units of type X (non-negative integer)
var 0..max_units: y_units;              % Number of units of type Y (non-negative integer)
var 0..(support_per_x*max_units + support_per_y*max_units): total_support; % Total support points

% Constraints
% --- Total unit capacity constraint (manpower/budget limit) ---
constraint
  x_units + y_units <= max_units;

% --- Minimum combined strength requirement ---
constraint
  2 * x_units + y_units >= min_strength;

% --- Force composition balance (imbalance limit) ---
constraint
  x_units - 2 * y_units <= max_imbalance;

% --- Define total support points from unit allocations ---
constraint
  total_support = support_per_x * x_units + support_per_y * y_units;

% Objective
solve minimize total_support;