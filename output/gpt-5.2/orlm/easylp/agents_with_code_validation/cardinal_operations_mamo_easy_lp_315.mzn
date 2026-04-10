% Parameters
int: min_effort = 100;          % Minimum required combined effort: X + 2Y + Z >= 100
int: max_effort2 = 200;         % Maximum allowed: 2X + Y <= 200
int: max_diff_xz = 50;          % Maximum allowed difference: X - Z <= 50

int: cost_x = 5;                % Support points per unit of X
int: cost_y = 6;                % Support points per unit of Y
int: cost_z = 4;                % Support points per unit of Z

% Variables
var 0..200: x;                  % Allocation to unit X (non-negative integer)
var 0..200: y;                  % Allocation to unit Y (non-negative integer)
var 0..200: z;                  % Allocation to unit Z (non-negative integer)

var 0..(cost_x*200 + cost_y*200 + cost_z*200): total_support;  % Total support points (integer)

% Constraints
% Effort requirement: X + 2Y + Z must meet or exceed the minimum effort
constraint x + 2*y + z >= min_effort;

% Upper bound on alternate effort measure: 2X + Y must not exceed the maximum
constraint 2*x + y <= max_effort2;

% Difference limit between X and Z: X - Z must not exceed the maximum allowed difference
constraint x - z <= max_diff_xz;

% Define total support points from per-unit costs (keeps objective separate)
constraint total_support = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_support;