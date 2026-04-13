% Parameters
% Operating costs per vehicle per day (USD)
int: costX = 5;
int: costY = 10;

% Minimum required vehicles of each type
int: minX = 30;
int: minY = 20;

% Maximum total vehicles allowed per day
int: maxTotal = 100;


% Variables
% Number of vehicles of each type to operate (whole numbers)
var minX..maxTotal: numX;
var minY..maxTotal: numY;

% Total daily operational cost (USD)
var 0..(costX*maxTotal + costY*maxTotal): totalCost;


% Constraints
% Ensure minimum vehicle requirements are satisfied (redundant with variable domains, kept for clarity)
constraint numX >= minX;
constraint numY >= minY;

% Enforce the overall fleet size limit per day
constraint numX + numY <= maxTotal;

% Define total daily operational cost from vehicle counts and per-vehicle costs
constraint totalCost = costX * numX + costY * numY;


% Objective
solve minimize totalCost;