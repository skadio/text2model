% Parameters
int: maxFleet = 1000;
int: minService = 500;
int: maxDiffYZ = 300;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..maxFleet: x;
var 0..maxFleet: y;
var 0..maxFleet: z;

var 0..(costX*maxFleet + costY*maxFleet + costZ*maxFleet): total_cost;

% Constraints
constraint x + y + z <= maxFleet;

constraint 2*x + y >= minService;

constraint abs(y - z) <= maxDiffYZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;