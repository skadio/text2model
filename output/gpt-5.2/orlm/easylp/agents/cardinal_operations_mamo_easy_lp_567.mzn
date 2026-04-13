% Parameters
int: total_budget = 1000;                 % Maximum total resources available
int: min_diff_XY = 200;                   % X must be at least 200 more than Y
int: max_abs_diff_ZX = 300;               % |Z - X| must not exceed 300
int: min_sum_YZ = 500;                    % Y + Z must be at least 500

int: impact_X = 2;                        % Impact points per unit allocated to X
int: impact_Y = 3;                        % Impact points per unit allocated to Y
int: impact_Z = 4;                        % Impact points per unit allocated to Z

% Variables
var 0..total_budget: x;                   % Units allocated to project X (non-negative integer)
var 0..total_budget: y;                   % Units allocated to project Y (non-negative integer)
var 0..total_budget: z;                   % Units allocated to project Z (non-negative integer)

var 0..(impact_X*total_budget + impact_Y*total_budget + impact_Z*total_budget): total_impact;
                                           % Total impact points (bounded for linearity)

% Constraints
% Total budget constraint: allocations cannot exceed the available resources
constraint x + y + z <= total_budget;

% Project X must be at least min_diff_XY units more than project Y
constraint x >= y + min_diff_XY;

% Absolute difference constraint between projects Z and X: |Z - X| <= max_abs_diff_ZX
constraint abs(z - x) <= max_abs_diff_ZX;

% Minimum combined allocation requirement for projects Y and Z
constraint y + z >= min_sum_YZ;

% Define total impact as the weighted sum of allocations (linear relationship)
constraint total_impact = impact_X * x + impact_Y * y + impact_Z * z;

% Objective
solve minimize total_impact;