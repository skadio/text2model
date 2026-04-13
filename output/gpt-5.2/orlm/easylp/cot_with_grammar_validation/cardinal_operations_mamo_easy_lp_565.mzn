% Parameters
int: BUDGET = 1000;

int: cX = 2;
int: cY = 3;
int: cZ = 4;

int: diffYZ_max = 50;

int: minXZ = 300;

int: x_more_than_2y = 100;

% Initiative-specific bounds (operational/strategic)
int: X_LB = 0;
int: X_UB = BUDGET;

int: Y_LB = 0;
int: Y_UB = BUDGET;

int: Z_LB = 0;
int: Z_UB = BUDGET;

% Variables
var X_LB..X_UB: X;
var Y_LB..Y_UB: Y;
var Z_LB..Z_UB: Z;

var 0..(cX*X_UB + cY*Y_UB + cZ*Z_UB): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X >= 2*Y + x_more_than_2y;

constraint abs(Y - Z) <= diffYZ_max;

constraint X + Z >= minXZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;