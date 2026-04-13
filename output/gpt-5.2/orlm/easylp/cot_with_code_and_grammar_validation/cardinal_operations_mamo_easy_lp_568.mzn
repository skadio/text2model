% Parameters
int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: total_limit = 100;

int: X_min = 0;
int: X_max = 50;
int: Y_min = 0;
int: Y_max = 40;
int: Z_min = 0;
int: Z_max = 60;

int: X_at_least_Y_plus = 10;
int: Z_at_most_Y_plus = 20;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

var 0..(costX*X_max + costY*Y_max + costZ*Z_max): total_cost;

% Constraints
constraint X + Y + Z <= total_limit;

constraint X >= Y + X_at_least_Y_plus;

constraint Z <= Y + Z_at_most_Y_plus;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;