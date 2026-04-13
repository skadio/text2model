include "globals.mzn";

% Data (embedded as requested)
int: costX = 100;
int: costY = 50;

int: fertPerX = 3;
int: fertPerY = 2;
int: fertMax = 1000;

int: minTotalAcres = 200;
int: maxDiff = 300;

int: maxX = 500;
int: maxY = 400;

% Decision variables: integer acres
var 0..maxX: x;  % acres of crop X
var 0..maxY: y;  % acres of crop Y

% Constraints
constraint fertPerX * x + fertPerY * y <= fertMax;
constraint x + y >= minTotalAcres;
constraint abs(x - y) <= maxDiff;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x_acres = ", show(x), "\n",
  "y_acres = ", show(y), "\n",
  "total_cost = ", show(totalCost), "\n"
];