% Parameters
int: min_effort = 100;              % Minimum required combined effort
int: max_effort = 200;              % Maximum allowed effort for second constraint
int: max_diff_xz = 50;              % Maximum allowed difference between X and Z

int: cost_x = 5;                    % Support points per unit of X
int: cost_y = 6;                    % Support points per unit of Y
int: cost_z = 4;                    % Support points per unit of Z

% Variable upper bounds (safe bounds derived from constraints)
int: ub_x = max_effort div 2;        % From 2*X + Y <= 200 and Y >= 0 => X <= 100
int: ub_y = max_effort;             % From 2*X + Y <= 200 and X >= 0 => Y <= 200
int: ub_z = min_effort + 2*ub_y + ub_x; % Loose safe bound to keep Z finite

% Variables
var 0..ub_x: x;                      % Allocation for unit X (integer, non-negative)
var 0..ub_y: y;                      % Allocation for unit Y (integer, non-negative)
var 0..ub_z: z;                      % Allocation for unit Z (integer, non-negative)

var 0..(cost_x*ub_x + cost_y*ub_y + cost_z*ub_z): total_support; % Total support points (integer)

% Constraints

% Total support points definition (linear cost aggregation)
constraint
  total_support = cost_x * x + cost_y * y + cost_z * z;

% Minimum combined effort requirement: X + 2Y + Z >= 100
constraint
  x + 2 * y + z >= min_effort;

% Maximum effort limitation: 2X + Y <= 200
constraint
  2 * x + y <= max_effort;

% Difference limit between X and Z: |X - Z| <= 50
constraint
  abs(x - z) <= max_diff_xz;

% Objective
solve minimize total_support;