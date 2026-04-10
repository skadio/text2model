% Parameters
% Per-unit costs (in dollars)
int: cost_X = 10;                 % Cost per unit for project X
int: cost_Y = 20;                 % Cost per unit for project Y
int: cost_Z = 30;                 % Cost per unit for project Z

% Constraint bounds
int: max_total_alloc = 10000;     % Upper bound on total allocation X+Y+Z
int: min_requirement = 5000;      % Lower bound on 2X + 3Y + Z
int: max_balance = 3000;          % Upper bound on (X - Y + Z)

% Variables
% Decision variables: non-negative integer allocations (units)
var 0..max_total_alloc: alloc_X;
var 0..max_total_alloc: alloc_Y;
var 0..max_total_alloc: alloc_Z;

% Total cost (bounded integer)
var 0..(cost_X*max_total_alloc + cost_Y*max_total_alloc + cost_Z*max_total_alloc): total_cost;

% Constraints
% --- Total allocation budget constraint ---
constraint
  alloc_X + alloc_Y + alloc_Z <= max_total_alloc;

% --- Minimum requirement constraint ---
constraint
  2 * alloc_X + 3 * alloc_Y + alloc_Z >= min_requirement;

% --- Balance/distribution constraint ---
constraint
  alloc_X - alloc_Y + alloc_Z <= max_balance;

% --- Total cost definition ---
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;