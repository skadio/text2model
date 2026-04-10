% Parameters
int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: totalMax = 10000;
int: reqMin = 5000;
int: balanceMax = 3000;

% Variables
var 0..totalMax: x;
var 0..totalMax: y;
var 0..totalMax: z;

var 0..(costX*totalMax + costY*totalMax + costZ*totalMax): totalCost;

% Constraints
constraint x + y + z <= totalMax;

constraint 2*x + 3*y + z >= reqMin;

constraint x - y + z <= balanceMax;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;