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
var 0..1000: X;
var 0..1000: Y;

var 0..1000000000: total_cost;

% Constraints
constraint perfX * X + perfY * Y >= perfMin;
constraint useX * X + useY * Y <= useMax;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;