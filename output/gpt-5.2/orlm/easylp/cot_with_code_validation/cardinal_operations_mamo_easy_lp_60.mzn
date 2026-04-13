% Parameters
int: costX = 2000;
int: costY = 3000;

int: perfX = 5;
int: perfY = 10;
int: perfMin = 50;

int: useX = 3;
int: useY = 4;
int: useMax = 40;

% Variables
var 0..useMax: X;
var 0..useMax: Y;

var int: totalCost;

% Constraints
constraint perfX * X + perfY * Y >= perfMin;
constraint useX * X + useY * Y <= useMax;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;