% Parameters
int: costX = 500;
int: costY = 1000;

int: minReq = 10;      % 5*X + 2*Y >= minReq
int: maxLimit = 25;    % 3*X + 4*Y <= maxLimit

int: X_lb = 0;
int: X_ub = 7;
int: Y_lb = 0;
int: Y_ub = 5;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;

var 0..(costX * X_ub + costY * Y_ub): totalCost;

% Constraints
constraint 5 * X + 2 * Y >= minReq;
constraint 3 * X + 4 * Y <= maxLimit;

% Investment difference at least one unit
constraint abs(X - Y) >= 1;

% Define total cost
constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;