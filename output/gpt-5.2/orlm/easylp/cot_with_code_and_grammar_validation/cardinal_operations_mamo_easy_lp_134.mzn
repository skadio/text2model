% Parameters
int: costX = 100;
int: costY = 200;

int: maxTotal = 50;

int: minX = 0;
int: maxX = 30;

int: minY = 0;
int: maxY = 20;

int: rhs = 10;

% Variables
var minX..maxX: X;
var minY..maxY: Y;

var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint X + Y <= maxTotal;

constraint 3 * X - Y >= rhs;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;