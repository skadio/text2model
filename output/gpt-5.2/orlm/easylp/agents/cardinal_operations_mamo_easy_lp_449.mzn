% Parameters
int: costX = 500;          % Cost per unit for Project X
int: costY = 1000;         % Cost per unit for Project Y

int: minReq = 10;          % Minimum requirement for 5*X + 2*Y
int: maxLimit = 25;        % Maximum limit for 3*X + 4*Y

int: minX = 0;             % Lower bound for X
int: maxX = 7;             % Upper bound for X
int: minY = 0;             % Lower bound for Y
int: maxY = 5;             % Upper bound for Y

int: minDiff = 1;          % Minimum required absolute difference |X - Y|

% Variables
var minX..maxX: investX;   % Integer investment units in Project X
var minY..maxY: investY;   % Integer investment units in Project Y

var int: totalCost;        % Total investment cost (to minimize)

% Constraints
% Link total cost to investment decisions
constraint
  totalCost = costX * investX + costY * investY;

% Minimum requirement: 5*X + 2*Y >= minReq
constraint
  5 * investX + 2 * investY >= minReq;

% Maximum limit: 3*X + 4*investY <= maxLimit
constraint
  3 * investX + 4 * investY <= maxLimit;

% Balanced resource distribution: |X - Y| >= minDiff
constraint
  abs(investX - investY) >= minDiff;

% Objective
solve minimize totalCost;