% Parameters
int: costX = 5;               % Operating cost per vehicle on route X
int: costY = 7;               % Operating cost per vehicle on route Y
int: costZ = 3;               % Operating cost per vehicle on route Z

int: maxTotalVehicles = 1000; % Upper bound on total vehicles across all routes
int: minTrafficWeighted = 500;% Minimum required value of 2*X + 3*Y
int: maxXZMinusY = 400;       % Upper bound on (X + Z - Y)
int: minYMinusZ = 100;        % Minimum required value of (Y - Z)

% Variables
var 0..maxTotalVehicles: x;   % Vehicles allocated to route X
var 0..maxTotalVehicles: y;   % Vehicles allocated to route Y
var 0..maxTotalVehicles: z;   % Vehicles allocated to route Z

% Total operating cost (bounded above by worst-case all routes at max)
var 0..(costX*maxTotalVehicles + costY*maxTotalVehicles + costZ*maxTotalVehicles): totalCost;

% Constraints
% Total vehicle capacity constraint across all routes
constraint x + y + z <= maxTotalVehicles;

% Minimum traffic/coverage requirement using weighted vehicles on X and Y
constraint 2 * x + 3 * y >= minTrafficWeighted;

% Balance/operational restriction relating X, Y, and Z allocations
constraint x + z - y <= maxXZMinusY;

% Demand/capacity requirement: Y must exceed Z by at least a fixed margin
constraint y - z >= minYMinusZ;

% Define total operating cost from per-route costs and allocations
constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;