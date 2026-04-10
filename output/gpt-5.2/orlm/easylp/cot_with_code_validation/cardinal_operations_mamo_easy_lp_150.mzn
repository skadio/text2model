% Parameters
int: capacity = 30;          % tons
int: wX = 2;                 % tons per unit of X
int: wY = 3;                 % tons per unit of Y
int: contract_min = 10;      % tons
int: contract_X_units = 4;   % units of X in contract expression
int: contract_Y_units = 1;   % units of Y in contract expression
int: cX = 5;                 % $ per unit of X
int: cY = 7;                 % $ per unit of Y

% Variables
var 0..(capacity div wX): x;
var 0..(capacity div wY): y;

var 0..(cX*(capacity div wX) + cY*(capacity div wY)): total_cost;

% Constraints
constraint wX*x + wY*y <= capacity;

constraint wX*contract_X_units*x + wY*contract_Y_units*y >= contract_min;

constraint total_cost = cX*x + cY*y;

% Objective
solve minimize total_cost;