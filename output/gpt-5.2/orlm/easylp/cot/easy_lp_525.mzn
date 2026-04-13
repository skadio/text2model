% Parameters (with values embedded)
int: max_XY = 150;
int: min_XZ = 100;
int: max_diff_YZ = 60;
int: X_not_more_than_10_less_than_Z = 10;

int: costX = 50;
int: costY = 80;
int: costZ = 30;

% Variables
var 0..150: X;         % patient care
var 0..150: Y;         % research and development
var 0..300: Z;         % administrative tasks (upper bound chosen safely)

var 0..1000000: TotalCost;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X >= Z - X_not_more_than_10_less_than_Z;

constraint TotalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize TotalCost;