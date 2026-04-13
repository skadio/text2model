% Parameters
int: total_budget = 1000;                 % Maximum total resources available
int: min_diff_XY = 200;                   % X must be at least this many units more than Y
int: max_abs_diff_ZX = 300;               % |Z - X| must be at most this many units
int: min_sum_YZ = 500;                    % Y + Z must be at least this many units

int: impact_X = 2;                        % Impact points per unit allocated to X
int: impact_Y = 3;                        % Impact points per unit allocated to Y
int: impact_Z = 4;                        % Impact points per unit allocated to Z

% Variables
var 0..total_budget: x;                   % Units allocated to project X
var 0..total_budget: y;                   % Units allocated to project Y
var 0..total_budget: z;                   % Units allocated to project Z

var 0..(impact_X*total_budget + impact_Y*total_budget + impact_Z*total_budget): total_impact;
                                          % Total impact points (bounded)

% Constraints
% Budget constraint: total allocation must not exceed available resources
constraint x + y + z <= total_budget;

% Project X must receive at least min_diff_XY more units than project Y
constraint x >= y + min_diff_XY;

% Difference between Z and X must be within max_abs_diff_ZX
constraint abs(z - x) <= max_abs_diff_ZX;

% Minimum combined allocation for projects Y and Z
constraint y + z >= min_sum_YZ;

% Define total impact as the weighted sum of allocations
constraint total_impact = impact_X * x + impact_Y * y + impact_Z * z;

% Objective
solve minimize total_impact;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_impact=", show(total_impact), "\n"
];