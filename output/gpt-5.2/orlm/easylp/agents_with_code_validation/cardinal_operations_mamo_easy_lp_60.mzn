% Parameters
int: costX = 2000;              % Cost per resource unit for Project X (dollars)
int: costY = 3000;              % Cost per resource unit for Project Y (dollars)

int: perfCoeffX = 5;            % Performance coefficient for X
int: perfCoeffY = 10;           % Performance coefficient for Y
int: minPerformance = 50;       % Minimum required performance score

int: usageCoeffX = 3;           % Usage coefficient for X
int: usageCoeffY = 4;           % Usage coefficient for Y
int: maxUsage = 40;             % Maximum allowed total usage

% Variable bounds derived from constraints:
% From 3*X + 4*Y <= 40 and nonnegativity => X <= floor(40/3)=13, Y <= floor(40/4)=10
int: maxX = 13;
int: maxY = 10;

% Variables
var 0..maxX: x;                 % Integer resource units allocated to Project X
var 0..maxY: y;                 % Integer resource units allocated to Project Y

var int: totalCost;             % Total cost (dollars)

% Constraints
% Bind total cost
constraint totalCost = costX * x + costY * y;

% Performance requirement: 5*x + 10*y >= 50
constraint perfCoeffX * x + perfCoeffY * y >= minPerformance;

% Resource usage limit: 3*x + 4*y <= 40
constraint usageCoeffX * x + usageCoeffY * y <= maxUsage;

% Objective
solve minimize totalCost;