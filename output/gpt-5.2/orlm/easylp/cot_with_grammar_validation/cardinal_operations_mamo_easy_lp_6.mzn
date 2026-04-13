% Parameters
int: costX = 5;
int: costY = 3;
int: minEffectiveness = 1000;
int: maxImbalance = 500;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..10000: totalCost;

% Constraints
constraint X + Y >= minEffectiveness;
constraint abs(X - 2 * Y) <= maxImbalance;
constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;