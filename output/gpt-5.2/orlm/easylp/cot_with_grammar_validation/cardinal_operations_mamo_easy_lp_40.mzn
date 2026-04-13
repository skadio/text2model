% Parameters
int: minX = 10;          % $10,000 in thousands
int: minY = 5;           % $5,000 in thousands
int: minTotal = 20;      % $20,000 in thousands
int: maxReturnCap = 5000; % $5,000,000 in "return-units" (since X contributes 3 per $1k, Y contributes 4 per $1k)

int: retX = 3;
int: retY = 4;

int: costX = 100;        % $ per unit of return
int: costY = 200;        % $ per unit of return

% Variables
var int: x;              % investment in X (thousands of dollars)
var int: y;              % investment in Y (thousands of dollars)
var int: totalCost;      % total cost in dollars

% Constraints
constraint x >= minX;
constraint y >= minY;

constraint x + y >= minTotal;

constraint retX * x + retY * y <= maxReturnCap;

constraint totalCost = costX * (retX * x) + costY * (retY * y);

% Objective
solve minimize totalCost;