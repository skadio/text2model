% Parameters
int: reqX = 2;
int: reqY = 3;
int: reqZ = 1;

int: minXY = 10;
int: max2XplusZ = 15;
int: minYminusZ = 5;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..1000000: total_resource;

% Constraints
constraint X + Y >= minXY;
constraint 2*X + Z <= max2XplusZ;
constraint Y - Z >= minYminusZ;

constraint total_resource = reqX*X + reqY*Y + reqZ*Z;

% Objective
solve minimize total_resource;