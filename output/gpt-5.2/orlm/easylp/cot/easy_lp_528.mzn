% Parameters (with values embedded)
int: MAX_TOTAL = 1000;
int: MIN_DIFF_XY = 50;
int: MAX_DIFF_ZX = 200;
int: MIN_YZ = 400;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

var 0..(costX*MAX_TOTAL + costY*MAX_TOTAL + costZ*MAX_TOTAL): total_cost;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;
constraint X >= Y + MIN_DIFF_XY;
constraint abs(Z - X) <= MAX_DIFF_ZX;
constraint Y + Z >= MIN_YZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;