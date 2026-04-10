% Parameters
int: min_XY = 1000;
int: max_diff_YZ = 500;
int: eq_XZ = 1500;

int: costX = 8;
int: costY = 5;
int: costZ = 2;

% Variables
var 0..eq_XZ: X;
var 0..eq_XZ: Z;
var 0..(min_XY + max_diff_YZ + eq_XZ): Y;

var int: total_cost;

% Constraints
constraint X + Y >= min_XY;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X + Z = eq_XZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;