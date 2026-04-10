% Parameters
int: capacity = 1000;                 % Maximum total production units
int: demand_X2_plus_Y = 500;          % Minimum required for 2*X + Y
int: inventory_X_plus_Z = 400;        % Minimum required for X + Z

int: costX = 2;                       % Unit cost of product X
int: costY = 3;                       % Unit cost of product Y
int: costZ = 4;                       % Unit cost of product Z

% Variables
var 0..capacity: X;                   % Units produced of product X (nonnegative integer)
var 0..capacity: Y;                   % Units produced of product Y (nonnegative integer)
var 0..capacity: Z;                   % Units produced of product Z (nonnegative integer)

% Upper bound: worst case if all capacity spent on the most expensive unit costs
var 0..(costX*capacity + costY*capacity + costZ*capacity): totalCost;

% Constraints
%--- Capacity constraint: total production cannot exceed plant capacity
constraint X + Y + Z <= capacity;

%--- Demand fulfillment: ensure enough output when counting X as double
constraint 2 * X + Y >= demand_X2_plus_Y;

%--- Inventory balance: maintain minimum combined production of X and Z
constraint X + Z >= inventory_X_plus_Z;

%--- Cost definition: link totalCost to per-unit costs and production quantities
constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;