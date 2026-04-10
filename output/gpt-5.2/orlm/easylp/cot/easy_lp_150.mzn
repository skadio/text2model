% Parameters (with values embedded)
int: capacity = 30;              % tons
int: weightX = 2;                % tons per unit of X
int: weightY = 3;                % tons per unit of Y
int: contractMinWeight = 10;     % tons
int: contractXUnits = 4;         % units of X in contract expression
int: contractYUnits = 1;         % units of Y in contract expression
int: costX = 5;                  % dollars per unit of X
int: costY = 7;                  % dollars per unit of Y

% Variables
var 0..(capacity div weightX): x;  % integer units of cargo X
var 0..(capacity div weightY): y;  % integer units of cargo Y
var 0..100000: total_cost;         % dollars (safe upper bound)

% Constraints
constraint weightX * x + weightY * y <= capacity;
constraint weightX * (contractXUnits * x) + weightY * (contractYUnits * y) >= contractMinWeight;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;