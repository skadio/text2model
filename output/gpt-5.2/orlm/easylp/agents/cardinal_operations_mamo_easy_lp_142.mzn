% Parameters
int: max_logistics = 50;          % Upper bound for 3*X + 2*Y
int: min_strength = 10;           % Lower bound for X + Y
int: coeff_x_log = 3;             % Coefficient of X in logistics constraint
int: coeff_y_log = 2;             % Coefficient of Y in logistics constraint
int: support_x = 4;               % Support points per unit of X
int: support_y = 5;               % Support points per unit of Y

% Variables
var 0..max_logistics: x;          % Allocation of unit X (nonnegative integer)
var 0..max_logistics: y;          % Allocation of unit Y (nonnegative integer)
var 0..(support_y * max_logistics): total_support;  % Total support points (objective helper)

% Constraints
% --- Logistics capacity constraint: 3*X + 2*Y must not exceed max_logistics
constraint
  coeff_x_log * x + coeff_y_log * y <= max_logistics;

% --- Minimum strength requirement: X + Y must be at least min_strength
constraint
  x + y >= min_strength;

% --- Define total support points based on allocations
constraint
  total_support = support_x * x + support_y * y;

% Objective
solve minimize total_support;