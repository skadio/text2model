% Parameters
int: budget = 1000;                 % Maximum total allocation across X, Y, Z
int: min_diff_XY = 50;              % X must be at least this much more than Y
int: max_abs_diff_ZX = 200;         % |Z - X| must not exceed this amount
int: min_sum_YZ = 400;              % Y + Z must be at least this amount

int: cost_X = 2;                    % Cost per unit for department X
int: cost_Y = 3;                    % Cost per unit for department Y
int: cost_Z = 4;                    % Cost per unit for department Z

% Variables
var 0..budget: x;                   % Allocation to department X (whole units)
var 0..budget: y;                   % Allocation to department Y (whole units)
var 0..budget: z;                   % Allocation to department Z (whole units)

% Upper bound: maximum possible cost if all budget spent in highest-cost dept
var 0..(cost_X*budget + cost_Y*budget + cost_Z*budget): total_cost;

% Constraints
% Budget limit: total allocation across all departments must not exceed budget
constraint x + y + z <= budget;

% Minimum difference: X must have at least min_diff_XY more units than Y
constraint x >= y + min_diff_XY;

% Balance requirement: absolute difference between Z and X must be within max_abs_diff_ZX
constraint abs(z - x) <= max_abs_diff_ZX;

% Minimum stocking: combined allocation for Y and Z must be at least min_sum_YZ
constraint y + z >= min_sum_YZ;

% Total cost definition: compute total_cost from per-unit costs and allocations
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;