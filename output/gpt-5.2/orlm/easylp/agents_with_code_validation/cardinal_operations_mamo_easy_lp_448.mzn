% Parameters
int: costX = 50;                 % Cost per unit for project X
int: costY = 100;                % Cost per unit for project Y

int: maxTotalUnits = 2000;       % Upper bound on combined allocation X + Y
int: minDiff = 500;              % Minimum required value of (X - 2*Y)
int: minX = 750;                 % Minimum allocation for project X

% Variables
var 0..maxTotalUnits: x;         % Units allocated to project X
var 0..maxTotalUnits: y;         % Units allocated to project Y

% Upper bound: worst case all units at higher cost
var 0..(costX*maxTotalUnits + costY*maxTotalUnits): totalCost; % Total cost

% Constraints
% Total allocation limit (budget/resource capacity)
constraint x + y <= maxTotalUnits;

% Minimum required difference between project allocations (project requirement)
constraint x - 2 * y >= minDiff;

% Minimum allocation for project X (infrastructure investment requirement)
constraint x >= minX;

% Define total cost from unit costs and allocations
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;