% Parameters
int: costX = 50;
int: costY = 30;
int: costZ = 20;

int: maxTotal = 500;

int: c1X = 3;
int: c1Y = -1;
int: c1Z = 1;
int: rhs1 = 100;

int: c2X = 1;
int: c2Y = -2;
int: c2Z = -1;
int: rhs2 = 200;

% Variables
var 0..maxTotal: x;
var 0..maxTotal: y;
var 0..maxTotal: z;

var 0..(costX*maxTotal + costY*maxTotal + costZ*maxTotal): totalCost;

% Constraints
constraint x + y + z <= maxTotal;

constraint c1X*x + c1Y*y + c1Z*z >= rhs1;

constraint c2X*x + c2Y*y + c2Z*z <= rhs2;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;