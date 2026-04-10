% Parameters (with values embedded)
int: CAP = 1000;
int: DEMAND = 1500;
int: EXTRA_X_OVER_Y = 200;
int: costX = 50;
int: costY = 70;

% Variables
var 0..CAP: x; % shipments on Route X (integer)
var 0..CAP: y; % shipments on Route Y (integer)

% Constraints
constraint x + y <= CAP;
constraint 2*x + 3*y >= DEMAND;
constraint x >= y + EXTRA_X_OVER_Y;

% Objective
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;