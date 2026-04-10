% Parameters
% Total available resource units (upper bound on total allocations)
int: total_allocation_limit = 1000;

% Minimum required allocations for each department
int: min_alloc_X = 200;
int: min_alloc_Y = 150;
int: min_alloc_Z = 100;

% Cost per unit allocated to each department
int: cost_per_unit_X = 50;
int: cost_per_unit_Y = 60;
int: cost_per_unit_Z = 70;

% Variables
% Integer allocations (whole-number resource units) to each department
var int: alloc_X;
var int: alloc_Y;
var int: alloc_Z;

% Total cost (integer, since all costs and allocations are integers)
var int: total_cost;

% Constraints
% Bound variables to reasonable ranges to help the solver
constraint alloc_X >= 0 /\ alloc_X <= total_allocation_limit;
constraint alloc_Y >= 0 /\ alloc_Y <= total_allocation_limit;
constraint alloc_Z >= 0 /\ alloc_Z <= total_allocation_limit;

% --- Minimum allocation requirements (operational constraints) ---
constraint alloc_X >= min_alloc_X;
constraint alloc_Y >= min_alloc_Y;
constraint alloc_Z >= min_alloc_Z;

% --- Total allocation (budget) limit across all departments ---
constraint alloc_X + alloc_Y + alloc_Z <= total_allocation_limit;

% --- Total cost definition (linking allocations to total_cost) ---
constraint total_cost =
    cost_per_unit_X * alloc_X
  + cost_per_unit_Y * alloc_Y
  + cost_per_unit_Z * alloc_Z;

% Objective
solve minimize total_cost;