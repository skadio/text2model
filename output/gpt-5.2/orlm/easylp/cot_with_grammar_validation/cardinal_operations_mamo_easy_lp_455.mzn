% Parameters
int: costX = 5000;
int: costY = 7000;

int: minX = 0;
int: maxX = 5;
int: minY = 0;
int: maxY = 4;

int: strengthReq = 10;
int: maxTotal = 8;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var int: total_cost;

% Constraints
constraint 2 * X + 3 * Y >= strengthReq;
constraint X + Y <= maxTotal;
constraint Y >= X + 1;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;