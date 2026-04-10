include "globals.mzn";

% Data (embedded as required)
int: maxTotal = 1000;
int: minWeighted = 1500;
int: maxDiff = 300;

int: maxX = 700;
int: maxY = 500;

int: costX = 10;
int: costY = 15;

% Decision variables: whole units shipped from each warehouse
var 0..maxX: x;   % units from warehouse X
var 0..maxY: y;   % units from warehouse Y

% Constraints
constraint x + y <= maxTotal;
constraint 2*x + 3*y >= minWeighted;
constraint abs(x - y) <= maxDiff;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];