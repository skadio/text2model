% Parameters
% Resource upper bounds
int: maxX = 30;        % maximum resources allocatable to Task X
int: maxY = 20;        % maximum resources allocatable to Task Y

% Constraint coefficients and limits
int: a1 = 5;           % coefficient for X in equipment-availability constraint
int: b1 = 3;           % coefficient for Y in equipment-availability constraint
int: cap1 = 200;       % upper bound for equipment-availability constraint

int: a2 = 10;          % coefficient for X in deadline constraint
int: b2 = 15;          % coefficient for Y in deadline constraint
int: req2 = 300;       % lower bound for deadline constraint

int: diffMax = 50;     % maximum allowed absolute difference |X - Y|

% Costs
int: costX = 10000;    % cost per unit of resource assigned to Task X (dollars)
int: costY = 15000;    % cost per unit of resource assigned to Task Y (dollars)

% Variables
var 0..maxX: x;        % integer resources allocated to Task X
var 0..maxY: y;        % integer resources allocated to Task Y
var 0..(costX*maxX + costY*maxY): totalCost;  % total cost in dollars

% Constraints
% Link total cost to allocated resources
constraint totalCost = costX * x + costY * y;

% Equipment availability: 5*X + 3*Y <= 200
constraint a1 * x + b1 * y <= cap1;

% Deadline requirement: 10*X + 15*Y >= 300
constraint a2 * x + b2 * y >= req2;

% Expertise limitation: |X - Y| <= 50
constraint abs(x - y) <= diffMax;

% Objective
solve minimize totalCost;