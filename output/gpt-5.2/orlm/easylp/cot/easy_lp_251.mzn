% Parameters (with values embedded)
int: maxTotalHours = 24;
int: minDiffXY = 2;
int: maxYZ = 16;

int: costX = 8;
int: costY = 6;
int: costZ = 5;

int: lbX = 0; int: ubX = 10;
int: lbY = 0; int: ubY = 8;
int: lbZ = 0; int: ubZ = 6;

% Variables
var lbX..ubX: X;
var lbY..ubY: Y;
var lbZ..ubZ: Z;
var 0..(costX*ubX + costY*ubY + costZ*ubZ): totalCost;

% Constraints
constraint X + Y + Z <= maxTotalHours;
constraint X >= Y + minDiffXY;
constraint Y + Z <= maxYZ;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;