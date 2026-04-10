include "globals.mzn";

% Data (embedded from problem statement)
int: maxFleet = 1000;
int: minService = 500;
int: maxDiffYZ = 300;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Decision variables: number of ships allocated to each route (whole numbers)
var 0..maxFleet: x;   % Route X
var 0..maxFleet: y;   % Route Y
var 0..maxFleet: z;   % Route Z

% Constraints
constraint x + y + z <= maxFleet;
constraint 2*x + y >= minService;
constraint abs(y - z) <= maxDiffYZ;

% Objective: minimize total operational cost
var 0..(costX*maxFleet + costY*maxFleet + costZ*maxFleet): totalCost;
constraint totalCost = costX*x + costY*y + costZ*z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];