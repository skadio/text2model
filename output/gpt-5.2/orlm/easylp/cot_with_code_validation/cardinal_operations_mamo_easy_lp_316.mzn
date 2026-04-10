% Parameters
int: TOTAL_MAX = 1000;
int: MIN_STRENGTH = 400;
int: YZ_MAX = 600;

int: costX = 4;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..TOTAL_MAX: X;
var 0..TOTAL_MAX: Y;
var 0..TOTAL_MAX: Z;

var 0..(costX*TOTAL_MAX + costY*TOTAL_MAX + costZ*TOTAL_MAX): total_cost;

% Constraints
constraint X + Y + Z <= TOTAL_MAX;
constraint 2*X + Y >= MIN_STRENGTH;
constraint Y + Z <= YZ_MAX;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;