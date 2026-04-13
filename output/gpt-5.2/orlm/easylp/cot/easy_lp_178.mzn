% Parameters (with values embedded)
int: Budget = 5000;
int: cX = 20;
int: cY = 15;
int: cZ = 30;

int: offset_X = 2000;   % X >= 2000 + (-3)*Y
int: coeff_XY = -3;

int: offset_Z = 1000;   % Z >= 1000 + Y

% Variables
var 0..Budget: X;
var 0..Budget: Y;
var 0..Budget: Z;

var 0..(cX*Budget + cY*Budget + cZ*Budget): TotalCost;

% Constraints
constraint X + Y + Z <= Budget;

constraint X >= offset_X + coeff_XY * Y;
constraint Z >= offset_Z + Y;

constraint TotalCost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize TotalCost;