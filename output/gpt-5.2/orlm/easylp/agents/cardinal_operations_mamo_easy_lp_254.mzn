% Parameters
int: budget_total = 1000;                 % Maximum total resources available
int: min_YZ_total = 800;                  % Minimum combined allocation to warehouses Y and Z
int: max_diff_XZ = 200;                   % Maximum allowed absolute difference between X and Z

int: cost_X = 2;                          % Cost per unit allocated to X
int: cost_Y = 3;                          % Cost per unit allocated to Y
int: cost_Z = 1;                          % Cost per unit allocated to Z

% Variables
var 0..budget_total: alloc_X;             % Units allocated to warehouse X (integer, non-negative)
var 0..budget_total: alloc_Y;             % Units allocated to warehouse Y (integer, non-negative)
var 0..budget_total: alloc_Z;             % Units allocated to warehouse Z (integer, non-negative)

var 0..(cost_X*budget_total + cost_Y*budget_total + cost_Z*budget_total): total_cost;
                                          % Total cost in dollars (integer)

% Constraints
% --- Total allocation budget constraint ---
constraint alloc_X + alloc_Y + alloc_Z <= budget_total;

% --- Minimum demand constraint for warehouses Y and Z ---
constraint alloc_Y + alloc_Z >= min_YZ_total;

% --- Balance constraint between warehouses X and Z ---
constraint abs(alloc_X - alloc_Z) <= max_diff_XZ;

% --- Total cost definition ---
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;