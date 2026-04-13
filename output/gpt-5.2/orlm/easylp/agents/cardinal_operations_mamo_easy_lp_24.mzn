% Parameters
int: maxVehicles = 50;              % Maximum total number of vehicles available
int: minCapacityUnits = 40;         % Minimum required combined capacity units

int: capPerX = 3;                   % Capacity contribution per vehicle on route X
int: capPerY = 2;                   % Capacity contribution per vehicle on route Y

int: fuelPerX = 2;                  % Fuel units consumed per vehicle on route X
int: fuelPerY = 3;                  % Fuel units consumed per vehicle on route Y


% Variables
var 0..maxVehicles: xVehicles;      % Vehicles allocated to route X (integer, nonnegative)
var 0..maxVehicles: yVehicles;      % Vehicles allocated to route Y (integer, nonnegative)

% Total fuel units (upper bound: all vehicles could be on either route)
var 0..(fuelPerX*maxVehicles + fuelPerY*maxVehicles): totalFuel;


% Constraints
% Vehicle availability limit (do not exceed total fleet)
constraint
  xVehicles + yVehicles <= maxVehicles;

% Minimum combined capacity requirement
constraint
  capPerX * xVehicles + capPerY * yVehicles >= minCapacityUnits;

% Define total fuel consumption from allocations
constraint
  totalFuel = fuelPerX * xVehicles + fuelPerY * yVehicles;


% Objective
solve minimize totalFuel;