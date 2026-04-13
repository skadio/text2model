% Parameters
int: costX = 5;                 % Cost per unit allocated to project X
int: costY = 8;                 % Cost per unit allocated to project Y

int: maxRes1 = 50;              % Upper bound for x + 2*y
int: minTotalRes = 10;          % Lower bound for x + y
int: maxDiff = 20;              % Upper bound for y - x/2

int: x_lb = 0;                  % Minimum allocation for project X
int: x_ub = 25;                 % Maximum allocation for project X
int: y_lb = 0;                  % Minimum allocation for project Y
int: y_ub = 30;                 % Maximum allocation for project Y

% Variables
var x_lb..x_ub: x;              % Integer resource allocation to project X
var y_lb..y_ub: y;              % Integer resource allocation to project Y
var int: total_cost;            % Total cost to minimize

% Constraints

% Resource capacity: combined allocation for X and twice Y cannot exceed limit
constraint x + 2 * y <= maxRes1;

% Minimum total allocation: ensure sufficient combined resources for X and Y
constraint x + y >= minTotalRes;

% Difference/strategic constraint (avoid fractional coefficient by scaling):
% y - x/2 <= maxDiff  <=>  2*y - x <= 2*maxDiff
constraint 2 * y - x <= 2 * maxDiff;

% Define total cost from per-unit costs and allocations
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;