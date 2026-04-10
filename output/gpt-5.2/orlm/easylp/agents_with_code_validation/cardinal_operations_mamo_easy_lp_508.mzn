% Parameters
int: budget = 1000;                 % Maximum total investment allowed
int: min_expr = 200;                % Minimum value for 5*X - 2*Y
int: max_diff_ZY = 300;             % Maximum allowed value of (Z - Y)
int: min_gap_XZ = 50;               % Minimum required value of (X - Z)

int: costX = 2;                     % Cost per unit invested in project X
int: costY = 3;                     % Cost per unit invested in project Y
int: costZ = 4;                     % Cost per unit invested in project Z

% Variables
var 0..budget: investX;             % Investment in project X (integer, nonnegative)
var 0..budget: investY;             % Investment in project Y (integer, nonnegative)
var 0..budget: investZ;             % Investment in project Z (integer, nonnegative)

var 0..(costX*budget + costY*budget + costZ*budget): total_cost; % Total cost to minimize

% Constraints
% Budget limit on total investment
constraint investX + investY + investZ <= budget;

% Minimum requirement on linear expression: 5*X - 2*Y
constraint 5 * investX - 2 * investY >= min_expr;

% Maximum allowed difference between Z and Y: (Z - Y) <= max_diff_ZY
constraint investZ - investY <= max_diff_ZY;

% Minimum gap between X and Z: X >= Z + min_gap_XZ
constraint investX >= investZ + min_gap_XZ;

% Define total cost from per-unit costs
constraint total_cost = costX * investX + costY * investY + costZ * investZ;

% Objective
solve minimize total_cost;