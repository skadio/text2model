% Parameters
int: maxTours = 50;
int: minBalance = 40;
int: maxDiversity = 60;

int: costX = 500;
int: costY = 1000;

% Variables
var 0..maxTours: X;
var 0..maxTours: Y;
var 0..(maxTours * max(costX, costY)): totalCost;

% Constraints
constraint X + Y <= maxTours;
constraint 2 * X + 4 * Y >= minBalance;
constraint 3 * X - 1 * Y <= maxDiversity;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;