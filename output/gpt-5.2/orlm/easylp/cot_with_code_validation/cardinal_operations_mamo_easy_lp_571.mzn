% Parameters
int: reqX = 500;
int: reqY = 400;
int: reqZ = 700;
int: budget = 1000;
int: minDiff_2X_minus_Y = 200;
int: minDiff_Z_minus_Y = 50;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;
var 0..(3*budget): total_support;

% Constraints
constraint x <= reqX;
constraint y <= reqY;
constraint z <= reqZ;

constraint x + y + z <= budget;

constraint 2*x - y >= minDiff_2X_minus_Y;
constraint z - y >= minDiff_Z_minus_Y;

constraint total_support = x + y + z;

% Objective
solve minimize total_support;