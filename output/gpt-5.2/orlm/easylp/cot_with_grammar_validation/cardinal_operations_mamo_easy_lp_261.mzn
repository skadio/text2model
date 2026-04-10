% Parameters
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: totalHires = 50;

int: expX = 5;
int: expY = 3;
int: expZ = 7;
int: minTotalExp = 200;

int: minX = 10;
int: maxY = 20;

% Variables
var 0..totalHires: x;
var 0..totalHires: y;
var 0..totalHires: z;

var 0..(costX*totalHires + costY*totalHires + costZ*totalHires): totalCost;

% Constraints
constraint x + y + z = totalHires;

constraint expX*x + expY*y + expZ*z >= minTotalExp;

constraint x >= minX;
constraint y <= maxY;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;