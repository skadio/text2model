% Parameters (with values embedded)
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

int: maxTotal = 100;

int: capX = 50;
int: capY = 30;
int: capZ = 20;

% Variables
var 0..capX: x;
var 0..capY: y;
var 0..capZ: z;

var 0..(costX*capX + costY*capY + costZ*capZ): totalCost;

% Constraints
constraint x + y + z <= maxTotal;

constraint x >= 2*y + 10;
constraint y >= z + 5;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;