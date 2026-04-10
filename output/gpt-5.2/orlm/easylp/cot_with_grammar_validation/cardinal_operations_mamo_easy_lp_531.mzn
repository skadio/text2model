% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: capXY = 1000;
int: min2XplusZ = 500;
int: diffYZ = 200;
int: capXZ = 800;

% Variables
var 0..capXY: X;
var 0..capXY: Y;
var 0..max(capXZ, min2XplusZ): Z;

var int: totalCost;

% Constraints
constraint X + Y <= capXY;
constraint 2*X + Z >= min2XplusZ;
constraint Y - Z = diffYZ;
constraint X + Z <= capXZ;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;