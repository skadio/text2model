int: maxVehicles = 50;
int: demand = 100;

% Decision variables: number of vehicles of type X and Y
var 0..maxVehicles: x;
var 0..maxVehicles: y;

% Constraints
constraint x + y <= maxVehicles;
constraint 3*x + 2*y >= demand;

% Fuel consumption per vehicle
int: fuelX = 2;
int: fuelY = 3;

% Objective: minimize total fuel consumption
var int: totalFuel = fuelX*x + fuelY*y;
solve minimize totalFuel;

% Output (also includes the minimum fuel, already an integer)
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_fuel=", show(totalFuel), "\n"
];