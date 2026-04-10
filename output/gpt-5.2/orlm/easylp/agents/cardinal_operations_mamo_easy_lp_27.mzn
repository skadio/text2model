% Parameters
int: costX = 4;        % Cost per day for one vehicle of type X ($/day)
int: costY = 5;        % Cost per day for one vehicle of type Y ($/day)

int: capA = 1000;      % Road capacity upper bound
int: demB = 800;       % Delivery demand lower bound

int: aX = 2;           % Coefficient of X in capacity constraint
int: aY = 3;           % Coefficient of Y in capacity constraint
int: bX = 3;           % Coefficient of X in demand constraint
int: bY = 2;           % Coefficient of Y in demand constraint

% Safe explicit upper bounds for fleet sizes from capacity constraint:
% 2*X + 3*Y <= 1000 => X <= 500 and Y <= 333 (if the other is 0).
int: maxX = capA div aX;
int: maxY = capA div aY;

% Variables
var 0..maxX: numX;     % Number of vehicles of type X (integer, non-negative)
var 0..maxY: numY;     % Number of vehicles of type Y (integer, non-negative)

var 0..(costX*maxX + costY*maxY): totalCost; % Total daily operating cost ($)

% Constraints

%----------------------------
% Fleet feasibility constraints
%----------------------------

% Road capacity upper bound: 2*X + 3*Y <= 1000
constraint
  aX * numX + aY * numY <= capA;

% Delivery demand lower bound: 3*X + 2*Y >= 800
constraint
  bX * numX + bY * numY >= demB;

%----------------------------
% Cost definition constraint
%----------------------------

% Total daily operating cost definition: totalCost = 4*X + 5*Y
constraint
  totalCost = costX * numX + costY * numY;

% Objective
solve minimize totalCost;