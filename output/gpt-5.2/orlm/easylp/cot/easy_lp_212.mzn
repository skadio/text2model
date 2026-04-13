% Parameters (with values embedded)
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: min_XY = 50;
int: max_XZ = 100;
int: min_Y_minus_Z = 10;

% Upper bounds derived from constraints to keep variables bounded:
% From X + Z <= 100 and nonnegativity => X <= 100, Z <= 100
% From Y - Z >= 10 and Z <= 100 => Y >= 10 and Y <= 110 is sufficient for optimality search
int: UB_X = 100;
int: UB_Z = 100;
int: UB_Y = 110;

% Variables
var 0..UB_X: X;
var 0..UB_Y: Y;
var 0..UB_Z: Z;

var int: total_cost;

% Constraints
constraint X + Y >= min_XY;
constraint X + Z <= max_XZ;
constraint Y - Z >= min_Y_minus_Z;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;