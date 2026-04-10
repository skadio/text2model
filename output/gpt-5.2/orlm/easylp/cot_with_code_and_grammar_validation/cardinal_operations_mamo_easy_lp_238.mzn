% Parameters
int: Rmax = 5000;
int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var 0..Rmax: x;
var 0..Rmax: y;
var 0..Rmax: z;
var 0..(costX*Rmax + costY*Rmax + costZ*Rmax): totalCost;

% Constraints
constraint x + y + z <= Rmax;
constraint x >= 3 * y;
constraint z >= 2 * y;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;