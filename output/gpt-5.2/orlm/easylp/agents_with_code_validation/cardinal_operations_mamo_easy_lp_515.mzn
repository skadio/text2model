% Parameters
% Embedded data from the problem description (costs and capacity/traffic limits)
int: costX = 10;                 % Operating cost per vehicle on route X
int: costY = 15;                 % Operating cost per vehicle on route Y
int: costZ = 20;                 % Operating cost per vehicle on route Z

int: maxXY = 1000;               % Upper bound on vehicles allocated to X + Y
int: maxYZ = 800;                % Upper bound on vehicles allocated to Y + Z
int: minXZ = 500;                % Lower bound on vehicles allocated to X + Z

int: capX = 700;                 % Capacity limit for route X
int: capY = 600;                 % Capacity limit for route Y
int: capZ = 400;                 % Capacity limit for route Z


% Variables
% Decision variables: integer vehicle allocations per route (bounded by capacities)
var 0..capX: vehiclesX;          % Vehicles on route X
var 0..capY: vehiclesY;          % Vehicles on route Y
var 0..capZ: vehiclesZ;          % Vehicles on route Z

% Total operating cost (bounded safely by max possible cost under caps)
var 0..(costX*capX + costY*capY + costZ*capZ): totalCost;


% Constraints
% Define total cost from allocations
constraint
  totalCost = costX * vehiclesX + costY * vehiclesY + costZ * vehiclesZ;

% Pairwise upper-bound restrictions due to traffic/road capacity
constraint
  vehiclesX + vehiclesY <= maxXY;

constraint
  vehiclesY + vehiclesZ <= maxYZ;

% Minimum service-level requirement across routes X and Z
constraint
  vehiclesX + vehiclesZ >= minXZ;

% Note: Individual route capacity limits are enforced by variable domains.


% Objective
solve minimize totalCost;