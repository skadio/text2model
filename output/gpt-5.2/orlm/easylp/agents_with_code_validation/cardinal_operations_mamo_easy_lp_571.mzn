% Parameters
% Support requirement per unit allocated to each division (given in problem statement)
int: reqX = 500;
int: reqY = 400;
int: reqZ = 700;

% Total available resources (budget cap)
int: total_cap = 1000;

% Strategic guideline thresholds
int: min_diff_2X_minus_Y = 200;  % 2*X - Y >= 200
int: min_Z_minus_Y = 50;         % Z - Y >= 50

% Upper bound for allocations (nonnegative allocations cannot exceed total_cap)
int: alloc_ub = total_cap;

% Variables
% Whole-number allocations to each division (nonnegative, bounded)
var 0..alloc_ub: allocX;  % allocation to division X
var 0..alloc_ub: allocY;  % allocation to division Y
var 0..alloc_ub: allocZ;  % allocation to division Z

% Total support required in unit terms (objective value), bounded
var 0..(reqX*alloc_ub + reqY*alloc_ub + reqZ*alloc_ub): total_support;

% Constraints
% Link total_support to the weighted sum of allocations (support per division)
constraint
  total_support = reqX * allocX + reqY * allocY + reqZ * allocZ;

% Budget/resource cap: combined allocations cannot exceed total available resources
constraint
  allocX + allocY + allocZ <= total_cap;

% Strategic guideline: division X has higher operational demand (2*X - Y >= threshold)
constraint
  2 * allocX - allocY >= min_diff_2X_minus_Y;

% Strategic guideline: division Z must exceed division Y by at least the specified margin
constraint
  allocZ - allocY >= min_Z_minus_Y;

% Objective
solve minimize total_support;