% Parameters (with values embedded)
int: costX = 100;
int: costY = 200;

int: totalFundsMax = 50;

int: Xmin = 0;
int: Xmax = 30;
int: Ymin = 0;
int: Ymax = 20;

int: effectivenessMin = 10;

% Variables
var Xmin..Xmax: X;  % funding units for project X (integer)
var Ymin..Ymax: Y;  % funding units for project Y (integer)

var 0..(costX*Xmax + costY*Ymax): totalCost;

% Constraints
constraint X + Y <= totalFundsMax;
constraint 3 * X - Y >= effectivenessMin;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;