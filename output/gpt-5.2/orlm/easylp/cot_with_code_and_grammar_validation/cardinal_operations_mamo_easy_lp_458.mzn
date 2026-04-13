% Parameters
int: costX = 5000;
int: costY = 3000;

int: maxTotalHours = 20;
int: minExpr = 5;
int: eqRHS = 10;

int: minX = 0;
int: maxX = 15;
int: minY = 0;
int: maxY = 10;

% Variables
var minX..maxX: x; % hours for Project X (integer)
var minY..maxY: y; % hours for Project Y (integer)

% Constraints
constraint x + y <= maxTotalHours;
constraint 3 * x - 4 * y >= minExpr;
constraint 2 * x + y = eqRHS;

% Objective
solve minimize costX * x + costY * y;