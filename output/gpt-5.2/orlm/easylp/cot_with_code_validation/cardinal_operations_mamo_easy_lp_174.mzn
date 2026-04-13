% Parameters
int: Bmax = 5000;
int: reach_min = 2000;
int: extra_limit = 1000;

int: costX = 100;
int: costY = 50;
int: costZ = 20;

% Variables
var 0..Bmax: X;
var 0..Bmax: Y;
var 0..Bmax: Z;

var 0..(costX*Bmax + costY*Bmax + costZ*Bmax): total_cost;

% Constraints
constraint X + Y + Z <= Bmax;

constraint 5*X - 3*Y + Z >= reach_min;

constraint (X + Z) - 2*Y <= extra_limit;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;