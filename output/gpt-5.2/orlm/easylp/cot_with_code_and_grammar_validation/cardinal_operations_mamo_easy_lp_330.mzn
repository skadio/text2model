% Parameters
int: max_XY = 100;
int: max_ZW = 200;
int: min_XZ = 50;
int: min_YW = 70;

int: costX = 10;
int: costY = 15;
int: costZ = 25;
int: costW = 30;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_ZW: Z;
var 0..max_ZW: W;

var 0..(costX*max_XY + costY*max_XY + costZ*max_ZW + costW*max_ZW): totalCost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint totalCost = costX*X + costY*Y + costZ*Z + costW*W;

% Objective
solve minimize totalCost;