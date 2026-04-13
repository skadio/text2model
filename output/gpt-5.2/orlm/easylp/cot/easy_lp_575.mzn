% Parameters (with values embedded)
int: maxFleet = 1000;
int: minService = 500;
int: maxDiffYZ = 300;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..maxFleet: x;  % ships on route X
var 0..maxFleet: y;  % ships on route Y
var 0..maxFleet: z;  % ships on route Z

var 0..(costX*maxFleet + costY*maxFleet + costZ*maxFleet): totalCost;

% Constraints
constraint x + y + z <= maxFleet;
constraint 2*x + y >= minService;
constraint abs(y - z) <= maxDiffYZ;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "minimum_total_operational_cost=", show(totalCost), "\n"
];