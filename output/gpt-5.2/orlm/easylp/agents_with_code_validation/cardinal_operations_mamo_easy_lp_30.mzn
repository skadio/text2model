% Parameters
int: maxVehicles = 50;                 % Maximum total number of vehicles allowed
int: minRequiredCapacity = 100;        % Minimum required combined capacity

int: capCoeffX = 3;                    % Capacity contribution coefficient for type X
int: capCoeffY = 2;                    % Capacity contribution coefficient for type Y

int: fuelPerX = 2;                     % Fuel units consumed per vehicle of type X
int: fuelPerY = 3;                     % Fuel units consumed per vehicle of type Y

% Variables
var 0..maxVehicles: xVehicles;         % Number of vehicles of type X
var 0..maxVehicles: yVehicles;         % Number of vehicles of type Y
var 0..(fuelPerX*maxVehicles + fuelPerY*maxVehicles): totalFuel; % Total fuel consumption

% Constraints
% Vehicle-count limit: total number of vehicles cannot exceed the maximum allowed
constraint xVehicles + yVehicles <= maxVehicles;

% Demand satisfaction: combined capacity must meet or exceed the minimum required
constraint capCoeffX * xVehicles + capCoeffY * yVehicles >= minRequiredCapacity;

% Fuel accounting: total fuel equals per-vehicle fuel consumption summed over both types
constraint totalFuel = fuelPerX * xVehicles + fuelPerY * yVehicles;

% Objective
solve minimize totalFuel;