% Transportation resource allocation (integer linear optimization)
% Embedded data (no .dzn needed)

int: maxVehicles = 50;
int: demand = 100;

% Vehicle capacities contribution to meeting demand:
int: capX = 3;
int: capY = 2;

% Fuel per vehicle:
int: fuelX = 2;
int: fuelY = 3;

% Decision variables: number of vehicles of each type (integers, nonnegative)
var 0..maxVehicles: x;   % type X
var 0..maxVehicles: y;   % type Y

% Constraints
constraint x + y <= maxVehicles;
constraint capX * x + capY * y >= demand;

% Objective: minimize total fuel consumption
var int: totalFuel = fuelX * x + fuelY * y;

solve minimize totalFuel;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "Minimum total fuel (rounded) = ", show(totalFuel), "\n"
];