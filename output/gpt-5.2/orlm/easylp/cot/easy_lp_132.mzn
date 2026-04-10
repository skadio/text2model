% Parameters (with values embedded)
int: costX = 4;
int: costY = 5;
int: maxBudget = 100;
int: minRequirement = 50;

% Variables
var 0..maxBudget: X;
var 0..maxBudget: Y;
var 0..(costX*maxBudget + costY*maxBudget): totalCost;

% Constraints
constraint X + 2*Y <= maxBudget;
constraint 3*X - Y >= minRequirement;
constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;