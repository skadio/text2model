% Parameters (with values embedded)
int: Rmax = 1000;
int: target1 = 3000;
int: rhs2 = -500;

int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Variables
var 0..Rmax: X;
var 0..Rmax: Y;
var 0..Rmax: Z;

var 0..(cX*Rmax + cY*Rmax + cZ*Rmax): total_cost;

% Constraints
constraint X + Y + Z <= Rmax;
constraint 4*X + 5*Y >= target1;
constraint Z - 3*Y >= rhs2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;