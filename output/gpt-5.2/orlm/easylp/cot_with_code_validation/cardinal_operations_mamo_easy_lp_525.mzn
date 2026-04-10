% Parameters
int: max_XY = 150;
int: min_XZ = 100;
int: max_diff_YZ = 60;
int: max_Z_minus_X = 10;

int: cost_X = 50;
int: cost_Y = 80;
int: cost_Z = 30;

% Upper bounds (derived from constraints to keep variables bounded)
int: ub_X = max_XY;                 % since X + Y <= 150 and Y >= 0
int: ub_Y = max_XY;                 % since X + Y <= 150 and X >= 0
int: ub_Z = max_XY + max_diff_YZ;   % since |Y - Z| <= 60 and Y <= 150 -> Z <= 210

% Variables
var 0..ub_X: X;
var 0..ub_Y: Y;
var 0..ub_Z: Z;

var 0..(cost_X*ub_X + cost_Y*ub_Y + cost_Z*ub_Z): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint abs(Y - Z) <= max_diff_YZ;
constraint Z - X <= max_Z_minus_X;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;