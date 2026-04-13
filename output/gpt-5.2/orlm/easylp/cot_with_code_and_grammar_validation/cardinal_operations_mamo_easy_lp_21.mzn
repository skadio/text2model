% Parameters
int: costX = 5000;
int: costY = 3000;
int: capTotal = 1000;
int: demandMin = 2000;
int: diffMin = 150;

% Variables
var 0..capTotal: x;
var 0..capTotal: y;
var 0..(costX*capTotal + costY*capTotal): totalCost;

% Constraints
constraint x + y <= capTotal;
constraint 3*x + 2*y >= demandMin;
constraint x - y >= diffMin;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;