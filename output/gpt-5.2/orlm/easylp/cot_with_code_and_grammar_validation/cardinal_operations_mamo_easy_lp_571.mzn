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
var 0..budget: total;

% Constraints
constraint total = x + y + z;
constraint total <= budget;

constraint 2 * x - y >= minDiff_2X_minus_Y;
constraint z - y >= minDiff_Z_minus_Y;

% (Optional) Respect stated division support requirements as lower bounds
constraint x >= reqX;
constraint y >= reqY;
constraint z >= reqZ;

% Objective
solve minimize total;