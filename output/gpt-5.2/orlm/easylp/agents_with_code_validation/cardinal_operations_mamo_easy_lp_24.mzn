% Parameters
int: maxVehicles = 50;          % Maximum total vehicles allowed (X + Y)
int: capX = 3;                  % Capacity contribution per vehicle on route X (in constraint)
int: capY = 2;                  % Capacity contribution per vehicle on route Y (in constraint)
int: minCapacity = 40;          % Minimum required combined capacity
int: fuelX = 2;                 % Fuel units per vehicle on route X
int: fuelY = 3;                 % Fuel units per vehicle on route Y

% Variables
var 0..maxVehicles: numX;       % Number of vehicles allocated to route X
var 0..maxVehicles: numY;       % Number of vehicles allocated to route Y
var 0..(fuelX*maxVehicles + fuelY*maxVehicles): totalFuel;  % Total fuel consumed

% Constraints
% Vehicle allocation limit (total vehicles on routes X and Y cannot exceed maxVehicles)
constraint
  numX + numY <= maxVehicles;

% Minimum combined capacity requirement (capX*numX + capY*numY must be at least minCapacity)
constraint
  capX * numX + capY * numY >= minCapacity;

% Define total fuel consumption from chosen allocations
constraint
  totalFuel = fuelX * numX + fuelY * numY;

% Objective
solve minimize totalFuel;