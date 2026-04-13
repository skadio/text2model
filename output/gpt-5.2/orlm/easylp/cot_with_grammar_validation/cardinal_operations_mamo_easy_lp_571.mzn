% Parameters
int: reqX = 500;
int: reqY = 400;
int: reqZ = 700;
int: budget = 1000;
int: minDiff2XminusY = 200;
int: minDiffZminusY = 50;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;
var 0..budget: total;

% Constraints
constraint total = x + y + z;

constraint total <= budget;

constraint 2*x - y >= minDiff2XminusY;

constraint z - y >= minDiffZminusY;

% Minimum required support per division (must meet or exceed stated needs)
constraint x >= reqX;
constraint y >= reqY;
constraint z >= reqZ;

% Objective
solve minimize total;