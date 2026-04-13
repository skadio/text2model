% Parameters (with values embedded)
int: maxVehicles = 50;
int: capX = 3;
int: capY = 2;
int: minCapacity = 40;
int: fuelX = 2;
int: fuelY = 3;

% Variables
var 0..maxVehicles: x;  % vehicles on route X
var 0..maxVehicles: y;  % vehicles on route Y
var 0..(fuelX*maxVehicles + fuelY*maxVehicles): totalFuel;

% Constraints
constraint x + y <= maxVehicles;
constraint capX * x + capY * y >= minCapacity;
constraint totalFuel = fuelX * x + fuelY * y;

% Objective
solve minimize totalFuel;