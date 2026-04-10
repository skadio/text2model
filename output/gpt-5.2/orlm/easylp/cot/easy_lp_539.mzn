% Parameters (with values embedded)
int: BUDGET = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 300;
int: costY = 500;
int: costZ = 200;

int: diffXY = 50;
int: diffYZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X - Y <= diffXY;
constraint Y >= Z + diffYZ;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;