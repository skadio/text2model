% Parameters
int: maxX = 20;                 % Maximum number of units of type X
int: maxY = 15;                 % Maximum number of units of type Y

int: a1X = 10;                  % Coefficient for X in strength metric 1
int: a1Y = 15;                  % Coefficient for Y in strength metric 1
int: minStrength1 = 100;        % Minimum required strength for metric 1

int: a2X = 20;                  % Coefficient for X in strength metric 2
int: a2Y = 30;                  % Coefficient for Y in strength metric 2
int: maxStrength2 = 200;        % Maximum allowed strength for metric 2

int: minDiffXY = 10;            % Minimum required difference X - Y

int: costX = 5000;              % Cost per unit of X (dollars)
int: costY = 7000;              % Cost per unit of Y (dollars)

% Variables
var 0..maxX: x;                 % Number of units of type X (integer)
var 0..maxY: y;                 % Number of units of type Y (integer)

var 0..(maxX*costX + maxY*costY): totalCost;  % Total cost (dollars)

% Constraints
% Total cost definition
constraint totalCost = costX * x + costY * y;

% Strength metric 1 must meet minimum requirement
constraint a1X * x + a1Y * y >= minStrength1;

% Strength metric 2 must not exceed maximum allowed
constraint a2X * x + a2Y * y <= maxStrength2;

% Enforce minimum difference between unit counts (X at least minDiffXY more than Y)
constraint x - y >= minDiffXY;

% Objective
solve minimize totalCost;