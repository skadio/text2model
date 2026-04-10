% Parameters
int: maxVehicles = 50;
int: demand = 100;

int: capX_coeff = 3;
int: capY_coeff = 2;

int: fuelX = 2;
int: fuelY = 3;

% Variables
var 0..maxVehicles: x; % number of vehicles type X
var 0..maxVehicles: y; % number of vehicles type Y
var 0..(fuelX*maxVehicles + fuelY*maxVehicles): totalFuel;

% Constraints
constraint x + y <= maxVehicles;
constraint capX_coeff * x + capY_coeff * y >= demand;
constraint totalFuel = fuelX * x + fuelY * y;

% Objective
solve minimize totalFuel;