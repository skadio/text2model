% Parameters
int: maxTours = 50;
int: minBalance = 40;          % 2*X + 4*Y >= 40
int: maxDiversity = 60;        % 3*X - Y <= 60
int: costX = 500;
int: costY = 1000;

% Variables
var 0..maxTours: X;
var 0..maxTours: Y;
var 0..(costX*maxTours + costY*maxTours): totalCost;

% Constraints
constraint X + Y <= maxTours;
constraint 2*X + 4*Y >= minBalance;
constraint 3*X - Y <= maxDiversity;

constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;