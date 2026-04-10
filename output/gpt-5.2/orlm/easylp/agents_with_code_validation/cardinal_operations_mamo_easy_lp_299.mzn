% Parameters
int: max_total_alloc = 1000;          % Upper bound on X+Y+Z
int: min_x_minus_y = 10;              % Constraint: X - Y >= 10
int: max_z_minus_y = 20;              % Constraint: Z - Y <= 20

int: cost_x = 5;                      % Unit cost for project X
int: cost_y = 2;                      % Unit cost for project Y
int: cost_z = 3;                      % Unit cost for project Z

% Variables
var 0..max_total_alloc: X;            % Allocation to project X (integer, nonnegative)
var 0..max_total_alloc: Y;            % Allocation to project Y (integer, nonnegative)
var 0..max_total_alloc: Z;            % Allocation to project Z (integer, nonnegative)

% Total cost (bounded linear expression)
var 0..(cost_x*max_total_alloc + cost_y*max_total_alloc + cost_z*max_total_alloc): total_cost;

% Constraints
% Total allocation limit: X + Y + Z <= max_total_alloc
constraint X + Y + Z <= max_total_alloc;

% Priority constraint: allocation to X must exceed Y by at least min_x_minus_y
constraint X - Y >= min_x_minus_y;

% Balance constraint: allocation to Z cannot exceed Y by more than max_z_minus_y
constraint Z - Y <= max_z_minus_y;

% Define total_cost as the linear cost of allocations
constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;