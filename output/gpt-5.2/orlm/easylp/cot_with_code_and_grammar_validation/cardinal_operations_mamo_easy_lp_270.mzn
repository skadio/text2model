% Parameters
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

int: totalMax = 100;

int: capX = 50;
int: capY = 30;
int: capZ = 20;

int: offsetXY = 10; % X >= 2*Y + 10
int: offsetYZ = 5;  % Y >= Z + 5

% Variables
var 0..capX: x;
var 0..capY: y;
var 0..capZ: z;

var 0..(costX*capX + costY*capY + costZ*capZ): totalCost;

% Constraints
constraint x + y + z <= totalMax;

constraint x >= 2 * y + offsetXY;
constraint y >= z + offsetYZ;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;