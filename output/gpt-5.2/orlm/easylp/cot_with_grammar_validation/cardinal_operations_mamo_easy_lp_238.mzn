% Parameters
int: Rmax = 5000;
int: cX = 100;
int: cY = 200;
int: cZ = 150;

% Variables
var 0..Rmax: X;
var 0..Rmax: Y;
var 0..Rmax: Z;
var 0..(cX*Rmax + cY*Rmax + cZ*Rmax): total_cost;

% Constraints
constraint X + Y + Z <= Rmax;
constraint X >= 3 * Y;
constraint Z >= 2 * Y;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;