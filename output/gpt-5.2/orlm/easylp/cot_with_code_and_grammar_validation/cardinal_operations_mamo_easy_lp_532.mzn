% Parameters
int: costX = 8;
int: costY = 5;
int: costZ = 2;

int: minXY = 1000;
int: maxDiffYZ = 500;
int: sumXZ = 1500;

% Variables
var 0..sumXZ: x;
var 0..(minXY + sumXZ): y;
var 0..sumXZ: z;
var 0..(costX*sumXZ + costY*(minXY + sumXZ) + costZ*sumXZ): totalCost;

% Constraints
constraint x + y >= minXY;
constraint x + z = sumXZ;
constraint abs(y - z) <= maxDiffYZ;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;