% Vehicle allocation between two routes X and Y
% Minimize total fuel subject to vehicle limit and capacity requirement.

include "globals.mzn";

% Embedded data (from problem statement)
int: maxVehicles = 50;
int: capReq = 40;                 % requirement: 3*X + 2*Y >= 40
int: fuelX = 2;
int: fuelY = 3;

% Decision variables: number of vehicles on each route (integers)
var 0..maxVehicles: x;             % vehicles on route X
var 0..maxVehicles: y;             % vehicles on route Y

% Constraints
constraint x + y <= maxVehicles;
constraint 3 * x + 2 * y >= capReq;

% Objective: minimize total fuel units consumed
var 0..(fuelX*maxVehicles + fuelY*maxVehicles): totalFuel = fuelX * x + fuelY * y;
solve minimize totalFuel;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalFuel = ", show(totalFuel), "\n",
  "roundedTotalFuel = ", show(round(totalFuel)), "\n"
];