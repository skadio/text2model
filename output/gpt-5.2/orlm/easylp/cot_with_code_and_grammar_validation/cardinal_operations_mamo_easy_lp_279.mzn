% Parameters
int: capacity = 50;
int: costX = 150;
int: costY = 200;
int: costZ = 100;

int: min_eff = 60;          % 2*X + 3*Y + Z >= 60
int: balance_diff = 10;     % |Y - Z| <= 10

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

% Constraints
constraint X + Y + Z <= capacity;

constraint 2*X + 3*Y + Z >= min_eff;

constraint abs(Y - Z) <= balance_diff;

% Objective
solve minimize costX*X + costY*Y + costZ*Z;