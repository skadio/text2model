% Transportation allocation: minimize fuel subject to capacity and vehicle limits

int: maxVehicles = 50;
int: capX = 3;          % capacity contribution per X vehicle in combined constraint
int: capY = 2;          % capacity contribution per Y vehicle in combined constraint
int: minCapacity = 40;  % required combined capacity

int: fuelX = 2;         % fuel units per X vehicle
int: fuelY = 3;         % fuel units per Y vehicle

var 0..maxVehicles: x;  % vehicles on route X
var 0..maxVehicles: y;  % vehicles on route Y

constraint x + y <= maxVehicles;
constraint capX * x + capY * y >= minCapacity;

var int: totalFuel = fuelX * x + fuelY * y;

solve minimize totalFuel;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_fuel_units = ", show(totalFuel), "\n"
];