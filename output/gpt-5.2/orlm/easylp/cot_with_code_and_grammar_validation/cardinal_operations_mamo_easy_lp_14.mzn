% Parameters
int: costX = 50;
int: costY = 70;
int: demand = 5000;
int: emissX = 10;
int: emissY = 15;
int: emissCap = 80000;

% Variables
var 0..demand: X;
var 0..demand: Y;
var int: totalCost;

% Constraints
constraint X + Y >= demand;
constraint emissX * X + emissY * Y <= emissCap;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;