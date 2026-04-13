% Parameters
int: costX = 5;
int: costY = 6;
int: costZ = 3;

int: maxXY = 1000;
int: maxYZ = 1200;
int: minDiffXZ = 200;

int: X_lb = 0;
int: X_ub = 700;
int: Y_lb = 0;
int: Y_ub = 500;
int: Z_lb = 0;
int: Z_ub = 600;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var Z_lb..Z_ub: Z;

var int: total_cost = costX * X + costY * Y + costZ * Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X - Z >= minDiffXZ;

% Objective
solve minimize total_cost;