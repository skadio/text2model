% Parameters
int: Rmax = 5000;
int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var 0..Rmax: X;
var 0..Rmax: Y;
var 0..Rmax: Z;
var 0..(Rmax * max([costX, costY, costZ])): totalCost;

% Constraints
constraint X + Y + Z <= Rmax;
constraint X >= 3 * Y;
constraint Z >= 2 * Y;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;