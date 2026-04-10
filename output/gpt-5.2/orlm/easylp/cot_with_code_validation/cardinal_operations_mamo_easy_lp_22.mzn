% Parameters
int: costX = 50;
int: costY = 60;

int: capRHS = 500;          % x + 2y <= 500
int: demRHS = 200;          % 3x + y >= 200
int: balanceLimit = 100;    % |x - y| <= 100

% Variables
var 0..capRHS: x;           % units of product X
var 0..capRHS: y;           % units of product Y
var int: totalCost;

% Constraints
constraint x + 2 * y <= capRHS;
constraint 3 * x + y >= demRHS;
constraint abs(x - y) <= balanceLimit;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;