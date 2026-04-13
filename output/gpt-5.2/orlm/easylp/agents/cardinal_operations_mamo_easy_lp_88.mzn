% Parameters
% Coefficients and RHS for constraints:
% 2*x + 3*y <= 40
% 4*x + 1*y >= 30
int: a1x = 2;
int: a1y = 3;
int: b1  = 40;

int: a2x = 4;
int: a2y = 1;
int: b2  = 30;

% Hourly costs
int: costX = 8;
int: costY = 12;

% Safe upper bounds for nonnegative integer hours (derived from 2*x + 3*y <= 40)
int: maxX = 20; % since 2*x <= 40
int: maxY = 13; % since 3*y <= 40 => y <= 13

% Variables
var 0..maxX: hoursX;  % integer hours scheduled for group X
var 0..maxY: hoursY;  % integer hours scheduled for group Y

% Total labor cost in integer dollars
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
% Link totalCost to the chosen hours and hourly costs
constraint totalCost = costX * hoursX + costY * hoursY;

% Operational requirement 1: 2*hoursX + 3*hoursY <= 40
constraint a1x * hoursX + a1y * hoursY <= b1;

% Operational requirement 2: 4*hoursX + 1*hoursY >= 30
constraint a2x * hoursX + a2y * hoursY >= b2;

% Objective
solve minimize totalCost;