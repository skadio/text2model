% Parameters (with values embedded)
int: reqX = 2;
int: reqY = 3;
int: reqZ = 1;

int: min_XY = 10;
int: max_2X_plus_Z = 15;
int: min_Y_minus_Z = 5;

% Variable bounds derived from constraints:
% 2*X + Z <= 15 with X,Z >= 0  => X <= 7, Z <= 15
% X + Y >= 10 with X >= 0, Y >= 0 => Y <= 10 + 15 = 25 (loose but finite)
int: X_ub = 7;
int: Y_ub = 25;
int: Z_ub = 15;

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;
var 0..Z_ub: Z;

% Constraints
constraint X + Y >= min_XY;
constraint 2 * X + Z <= max_2X_plus_Z;
constraint Y - Z >= min_Y_minus_Z;

% Objective
var int: total_resource = reqX * X + reqY * Y + reqZ * Z;
solve minimize total_resource;