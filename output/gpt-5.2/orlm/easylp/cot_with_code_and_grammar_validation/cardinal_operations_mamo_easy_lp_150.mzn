% Parameters
int: capacity = 30;          % total weight capacity (tons)
int: wX = 2;                 % weight per unit of X (tons)
int: wY = 3;                 % weight per unit of Y (tons)
int: reqX = 4;               % units of X in contract requirement
int: reqY = 1;               % units of Y in contract requirement
int: reqMinWeight = 10;      % minimum combined weight (tons)
int: cX = 5;                 % cost per unit of X ($)
int: cY = 7;                 % cost per unit of Y ($)

% Variables
var 0..(capacity div wX): x;
var 0..(capacity div wY): y;
var 0..(cX*(capacity div wX) + cY*(capacity div wY)): total_cost;

% Constraints
constraint wX*x + wY*y <= capacity;
constraint wX*reqX*x + wY*reqY*y >= reqMinWeight;
constraint total_cost = cX*x + cY*y;

% Objective
solve minimize total_cost;