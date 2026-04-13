% Parameters (with values embedded)
int: costX = 5000;
int: costY = 8000;

int: maxTotalUnits = 100;
int: minDiffXY = 20;          % X must be at least 20 more than Y
int: portfolioLimit = 150;    % X + 2Y <= 150

% Variables
var 0..maxTotalUnits: X;      % units allocated to Project X
var 0..maxTotalUnits: Y;      % units allocated to Project Y

% Constraints
constraint X + Y <= maxTotalUnits;
constraint X - Y >= minDiffXY;
constraint X + 2*Y <= portfolioLimit;

% Objective
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;