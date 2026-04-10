% Parameters (with values embedded)
int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: maxTotalAlloc = 10000;
int: minRequirement = 5000;
int: maxBalanceExpr = 3000;

% Variables
var 0..maxTotalAlloc: x; % allocation to project X
var 0..maxTotalAlloc: y; % allocation to project Y
var 0..maxTotalAlloc: z; % allocation to project Z

var int: totalCost;

% Constraints
constraint x + y + z <= maxTotalAlloc;
constraint 2*x + 3*y + z >= minRequirement;
constraint x - y + z <= maxBalanceExpr;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;