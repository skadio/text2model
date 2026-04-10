% Parameters
int: budget = 10000;

int: minX = 200;
int: maxX = 5000;

int: minY = 100;
int: maxY = 4000;

int: minZ = 800;
int: maxZ = budget; % implicit upper bound

% Return constraint coefficients (use integer scaling by 100 to avoid floats)
int: rX = 7;
int: rY = -2;
int: rZ = -5;

% Second constraint parameters
int: rhs2 = 3000;

% Cost coefficients
int: cX = 50;
int: cY = 30;
int: cZ = 20;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(cX*maxX + cY*maxY + cZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint rX * X + rY * Y + rZ * Z >= 0;

constraint X - 2 * Y + Z >= rhs2;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;