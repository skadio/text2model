% Parameters
% Cost per unit of resource allocated
int: costX = 4;
int: costY = 5;

% Constraint coefficients and right-hand sides
int: maxBudget = 100;     % x + 2y <= 100
int: minRequirement = 50; % 3x - y >= 50


% Variables
% Resource allocations (whole numbers, non-negative)
var 0..maxBudget: x;  % units allocated to Project X
var 0..maxBudget: y;  % units allocated to Project Y

% Objective value (bounded for safe linear usage)
var 0..(costX * maxBudget + costY * maxBudget): totalCost;


% Constraints
% Link objective variable
constraint totalCost = costX * x + costY * y;

% Budget limitation: combined allocation (X + 2Y) must not exceed maxBudget
constraint x + 2 * y <= maxBudget;

% Strategic/minimum requirement: (3X - Y) must be at least minRequirement
constraint 3 * x - y >= minRequirement;


% Objective
solve minimize totalCost;