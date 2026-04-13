include "globals.mzn";

% Data (embedded from problem statement)
int: costX = 20;
int: costY = 30;

int: maxTotal = 1000;
int: minDiff  = 200;
int: maxCombo = 1500;

int: maxX = 800;
int: maxY = 600;

% Decision variables: whole-number allocations
var 0..maxX: x;   % units allocated to project X
var 0..maxY: y;   % units allocated to project Y

% Constraints
constraint x + y <= maxTotal;
constraint abs(x - y) >= minDiff;
constraint 2*x + y <= maxCombo;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];