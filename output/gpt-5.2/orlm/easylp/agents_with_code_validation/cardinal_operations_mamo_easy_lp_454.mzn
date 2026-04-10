% Parameters
int: maxX = 30;                 % Maximum resources for Task X
int: maxY = 20;                 % Maximum resources for Task Y

int: a1 = 5;                    % Coefficient for X in equipment constraint
int: b1 = 3;                    % Coefficient for Y in equipment constraint
int: rhs1 = 200;                % Equipment availability upper bound

int: a2 = 10;                   % Coefficient for X in deadline constraint
int: b2 = 15;                   % Coefficient for Y in deadline constraint
int: rhs2 = 300;                % Deadline requirement lower bound

int: diffLimit = 50;            % Max allowed absolute difference |X - Y|

int: costX = 10000;             % Cost per unit for Task X (dollars)
int: costY = 15000;             % Cost per unit for Task Y (dollars)

% Variables
var 0..maxX: x;                 % Integer resources allocated to Task X
var 0..maxY: y;                 % Integer resources allocated to Task Y

var 0..(costX*maxX + costY*maxY): totalCost;  % Total cost (dollars)

% Constraints

% Cost definition: total cost equals per-unit costs times allocated resources
constraint
  totalCost = costX * x + costY * y;

% Equipment availability constraint (upper bound)
constraint
  a1 * x + b1 * y <= rhs1;

% Deadline/production requirement constraint (lower bound)
constraint
  a2 * x + b2 * y >= rhs2;

% Expertise limitation: absolute difference between allocations is bounded
constraint
  abs(x - y) <= diffLimit;

% Objective
solve minimize totalCost;