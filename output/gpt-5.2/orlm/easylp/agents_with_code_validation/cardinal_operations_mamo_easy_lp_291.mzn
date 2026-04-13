% Parameters
int: total_allocation_cap = 1000;      % Maximum total resources available
int: min_alloc_X = 200;               % Minimum allocation for department X
int: min_alloc_Y = 150;               % Minimum allocation for department Y
int: min_alloc_Z = 120;               % Minimum allocation for department Z

int: cost_per_unit_X = 10;            % Cost per unit allocated to X
int: cost_per_unit_Y = 20;            % Cost per unit allocated to Y
int: cost_per_unit_Z = 30;            % Cost per unit allocated to Z

% Variables
var 0..total_allocation_cap: alloc_X; % Integer allocation to department X
var 0..total_allocation_cap: alloc_Y; % Integer allocation to department Y
var 0..total_allocation_cap: alloc_Z; % Integer allocation to department Z

% Upper bound: allocate all units at the maximum per-unit cost
var 0..(total_allocation_cap * max([cost_per_unit_X, cost_per_unit_Y, cost_per_unit_Z])): total_cost;

% Constraints
% Minimum allocation requirements for each department
constraint alloc_X >= min_alloc_X;
constraint alloc_Y >= min_alloc_Y;
constraint alloc_Z >= min_alloc_Z;

% Total allocation must not exceed the overall cap
constraint alloc_X + alloc_Y + alloc_Z <= total_allocation_cap;

% Define total cost as the sum of per-unit costs times allocations
constraint total_cost =
    cost_per_unit_X * alloc_X
  + cost_per_unit_Y * alloc_Y
  + cost_per_unit_Z * alloc_Z;

% Objective
solve minimize total_cost;