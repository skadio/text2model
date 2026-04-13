% Parameters
int: BUDGET = 1000;
int: cX = 50;
int: cY = 30;
int: cZ = 20;

int: x_extra_over_2y = 200;
int: z_extra_over_y = 150;

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

constraint X >= 2*Y + x_extra_over_2y;
constraint Z >= Y + z_extra_over_y;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;