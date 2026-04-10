% Parameters (with values embedded)
int: maxVehicles = 50;
int: minCapacity = 100;
int: capX = 3;
int: capY = 2;
int: fuelX = 2;
int: fuelY = 3;

% Variables
var 0..maxVehicles: x;  % number of type X vehicles
var 0..maxVehicles: y;  % number of type Y vehicles

% Constraints
constraint x + y <= maxVehicles;
constraint capX * x + capY * y >= minCapacity;

% Objective
var 0..(fuelX*maxVehicles + fuelY*maxVehicles): totalFuel;
constraint totalFuel = fuelX * x + fuelY * y;

solve minimize totalFuel;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_fuel=", show(totalFuel), "\n"
];