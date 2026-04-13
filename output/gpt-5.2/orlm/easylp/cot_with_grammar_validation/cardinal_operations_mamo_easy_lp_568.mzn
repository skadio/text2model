% Parameters
int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: totalMax = 100;

int: xMin = 0;
int: xMax = 50;
int: yMin = 0;
int: yMax = 40;
int: zMin = 0;
int: zMax = 60;

int: diffXY = 10;
int: diffZY = 20;

% Variables
var xMin..xMax: X;
var yMin..yMax: Y;
var zMin..zMax: Z;

var 0..(costX * xMax + costY * yMax + costZ * zMax): totalCost;

% Constraints
constraint X + Y + Z <= totalMax;

constraint X >= Y + diffXY;

constraint Z <= Y + diffZY;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;