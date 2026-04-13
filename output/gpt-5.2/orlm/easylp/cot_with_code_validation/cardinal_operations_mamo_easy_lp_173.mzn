% Parameters
int: B_max = 5000;

int: a1x = 3;  int: a1y = -1; int: a1z = 1;  int: b1 = 2000;   % 3X - Y + Z >= 2000
int: a2x = 1;  int: a2y = -2; int: a2z = 1;  int: b2 = 1000;   % X - 2Y + Z >= -1000  (equiv to X - 2Y - Z <= 1000)
int: a3x = 1;  int: a3y = -1; int: a3z = 3;  int: b3 = 1500;   % X - Y + 3Z >= 1500

int: cX = 60;
int: cY = 75;
int: cZ = 50;

% Variables
var 0..B_max: X;
var 0..B_max: Y;
var 0..B_max: Z;

var 0..(cX*B_max + cY*B_max + cZ*B_max): TotalCost;

% Constraints
constraint X + Y + Z <= B_max;

constraint a1x*X + a1y*Y + a1z*Z >= b1;
constraint a2x*X + a2y*Y + a2z*Z >= -b2;
constraint a3x*X + a3y*Y + a3z*Z >= b3;

constraint TotalCost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize TotalCost;