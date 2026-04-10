% Parameters
int: costX = 20;                 % Cost per unit for Project X
int: costY = 30;                 % Cost per unit for Project Y

int: totalAllocMax = 1000;       % Maximum total allocation across both projects
int: diffMin = 200;              % Minimum required difference between allocations (|X - Y| >= 200)
int: weightedMax = 1500;         % Upper bound for 2*X + Y

int: maxX = 800;                 % Maximum allocation for Project X
int: maxY = 600;                 % Maximum allocation for Project Y

% Variables
var 0..maxX: allocX;             % Integer allocation for Project X (whole units)
var 0..maxY: allocY;             % Integer allocation for Project Y (whole units)

var 0..(costX*maxX + costY*maxY): totalCost;  % Total cost in dollars (bounded)

% Constraints
% Link totalCost to the decision variables
constraint totalCost = costX * allocX + costY * allocY;

% Total allocation budget limit
constraint allocX + allocY <= totalAllocMax;

% Balance requirement: allocations must differ by at least diffMin
constraint abs(allocX - allocY) >= diffMin;

% Weighted resource cap: 2*X + Y upper bound
constraint 2 * allocX + allocY <= weightedMax;

% Objective
solve minimize totalCost;