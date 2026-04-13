% Parameters
int: costX = 5;
int: costY = 6;
int: costZ = 3;

int: X_lb = 0;
int: X_ub = 700;
int: Y_lb = 0;
int: Y_ub = 500;
int: Z_lb = 0;
int: Z_ub = 600;

int: capXY = 1000;
int: capYZ = 1200;
int: minDiffXZ = 200;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var 0..(costX*X_ub + costY*Y_ub + costZ*Z_ub): total_cost;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;
constraint X - Z >= minDiffXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;