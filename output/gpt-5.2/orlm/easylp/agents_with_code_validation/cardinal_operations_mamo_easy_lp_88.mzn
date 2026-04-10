% Parameters
% Coefficients and constants from the problem statement (embedded directly)
int: a1 = 2;      % coefficient for X in constraint 1
int: b1 = 3;      % coefficient for Y in constraint 1
int: c1 = 40;     % RHS for constraint 1 (<=)

int: a2 = 4;      % coefficient for X in constraint 2
int: b2 = 1;      % coefficient for Y in constraint 2
int: c2 = 30;     % RHS for constraint 2 (>=)

int: costX = 8;   % cost per hour for group X
int: costY = 12;  % cost per hour for group Y

% Variables
var 0..c1: hoursX;   % integer hours scheduled for group X (nonnegative, bounded by c1)
var 0..c1: hoursY;   % integer hours scheduled for group Y (nonnegative, bounded by c1)

% Upper bound: max cost if both variables hit their upper bound c1
var 0..(costX*c1 + costY*c1): totalCost;  % total labor cost

% Constraints
% Cost definition (linking totalCost with decision variables)
constraint totalCost = costX * hoursX + costY * hoursY;

% Operational hour constraints (from problem statement)
constraint a1 * hoursX + b1 * hoursY <= c1;
constraint a2 * hoursX + b2 * hoursY >= c2;

% Objective
solve minimize totalCost;