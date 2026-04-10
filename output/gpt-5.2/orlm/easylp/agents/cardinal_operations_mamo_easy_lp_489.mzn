% Parameters
int: maxX = 20;                 % Maximum number of unit X
int: maxY = 15;                 % Maximum number of unit Y

int: a1 = 10;                   % Coefficient for X in strength metric 1
int: b1 = 15;                   % Coefficient for Y in strength metric 1
int: minStrength1 = 100;        % Minimum required strength for metric 1

int: a2 = 20;                   % Coefficient for X in strength metric 2
int: b2 = 30;                   % Coefficient for Y in strength metric 2
int: maxStrength2 = 200;        % Maximum allowed strength for metric 2

int: minXminusY = 10;           % At least this many more X than Y

int: costX = 5000;              % Cost per unit X (USD)
int: costY = 7000;              % Cost per unit Y (USD)

% Variables
var 0..maxX: x;                 % Number of units of type X
var 0..maxY: y;                 % Number of units of type Y
var int: totalCost;             % Total cost in USD

% Constraints
% Bind totalCost to decision variables
constraint totalCost = costX * x + costY * y;

% Strength metric 1 (minimum)
constraint a1 * x + b1 * y >= minStrength1;

% Strength metric 2 (maximum)
constraint a2 * x + b2 * y <= maxStrength2;

% Balance constraint: X at least Y + 10
constraint x - y >= minXminusY;

% Objective
solve minimize totalCost;