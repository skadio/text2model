% Parameters
int: TOTAL_MAX = 1000;
int: MIN_2X_PLUS_Y = 500;
int: MAX_X_PLUS_3Z = 800;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..TOTAL_MAX: X;
var 0..TOTAL_MAX: Y;
var 0..TOTAL_MAX: Z;

var 0..(costX*TOTAL_MAX + costY*TOTAL_MAX + costZ*TOTAL_MAX): total_cost;

% Constraints
constraint X + Y + Z <= TOTAL_MAX;
constraint 2*X + Y >= MIN_2X_PLUS_Y;
constraint X + 3*Z <= MAX_X_PLUS_3Z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;