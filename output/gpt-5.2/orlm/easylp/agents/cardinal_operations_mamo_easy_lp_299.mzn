% Parameters
% Cost per unit allocation for each project (embedded from problem statement)
int: costX = 5;
int: costY = 2;
int: costZ = 3;

% Constraints data (embedded from problem statement)
int: max_total_allocation = 1000;     % X + Y + Z <= 1000
int: min_X_minus_Y = 10;              % X - Y >= 10
int: max_Z_minus_Y = 20;              % Z - Y <= 20


% Variables
var 0..max_total_allocation: X;       % Allocation to project X (integer, non-negative)
var 0..max_total_allocation: Y;       % Allocation to project Y (integer, non-negative)
var 0..max_total_allocation: Z;       % Allocation to project Z (integer, non-negative)

% Total cost upper bound uses max allocation for each project
var 0..(costX*max_total_allocation + costY*max_total_allocation + costZ*max_total_allocation): total_cost;


% Constraints
% Total allocation budget constraint: X + Y + Z <= 1000
constraint X + Y + Z <= max_total_allocation;

% Strategic priority constraint: X - Y >= 10
constraint X - Y >= min_X_minus_Y;

% Balanced distribution constraint: Z - Y <= 20
constraint Z - Y <= max_Z_minus_Y;

% Define total cost from allocations and per-unit costs
constraint total_cost = costX * X + costY * Y + costZ * Z;


% Objective
solve minimize total_cost;