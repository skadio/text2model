% Parameters
int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: maxTotal = 10000;
int: minRequirement = 5000;
int: maxBalance = 3000;

% Variables
var 0..maxTotal: x;
var 0..maxTotal: y;
var 0..maxTotal: z;

var 0..(costX*maxTotal + costY*maxTotal + costZ*maxTotal): totalCost;

% Constraints
constraint x + y + z <= maxTotal;

constraint 2*x + 3*y + z >= minRequirement;

constraint x - y + z <= maxBalance;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;