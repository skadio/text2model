% Parameters
int: MAX_TOTAL = 1000;
int: MIN_2X_PLUS_Y = 500;
int: MAX_X_PLUS_3Z = 800;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

var 0..(costX*MAX_TOTAL + costY*MAX_TOTAL + costZ*MAX_TOTAL): total_cost;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;

constraint 2*X + Y >= MIN_2X_PLUS_Y;

constraint X + 3*Z <= MAX_X_PLUS_3Z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;