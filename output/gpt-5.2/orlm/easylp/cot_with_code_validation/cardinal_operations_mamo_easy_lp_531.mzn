% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: XY_max = 1000;
int: twoX_plus_Z_min = 500;
int: Y_minus_Z_eq = 200;
int: XZ_max = 800;

% Variables
var 0..XY_max: X;
var 0..XY_max: Y;
var 0..XZ_max: Z;

var int: total_cost;

% Constraints
constraint X + Y <= XY_max;
constraint 2 * X + Z >= twoX_plus_Z_min;
constraint Y - Z == Y_minus_Z_eq;
constraint X + Z <= XZ_max;

constraint total_cost == costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;