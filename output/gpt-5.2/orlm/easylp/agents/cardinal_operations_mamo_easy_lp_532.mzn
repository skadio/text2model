% Parameters
% Unit costs per resource for each project (embedded from description)
int: cost_X = 8;
int: cost_Y = 5;
int: cost_Z = 2;

% Requirements (embedded from description)
int: min_XY = 1000;        % X + Y >= 1000
int: max_diff_YZ = 500;    % |Y - Z| <= 500
int: eq_XZ = 1500;         % X + Z = 1500

% Simple global upper bound for allocations derived from X+Z=1500 and nonnegativity
int: max_alloc = eq_XZ;

% Variables
var 0..max_alloc: alloc_X;  % resources allocated to project X (integer, nonnegative)
var 0..max_alloc: alloc_Y;  % resources allocated to project Y (integer, nonnegative)
var 0..max_alloc: alloc_Z;  % resources allocated to project Z (integer, nonnegative)

% Total cost (upper bound: all vars at max_alloc)
var 0..(cost_X*max_alloc + cost_Y*max_alloc + cost_Z*max_alloc): total_cost;

% Constraints
% Link total_cost to allocations and unit costs
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Minimum combined allocation requirement for projects X and Y
constraint
  alloc_X + alloc_Y >= min_XY;

% Exact combined allocation requirement for projects X and Z
constraint
  alloc_X + alloc_Z = eq_XZ;

% Balanced portfolio requirement: limit absolute difference between Y and Z
constraint
  abs(alloc_Y - alloc_Z) <= max_diff_YZ;

% Objective
solve minimize total_cost;