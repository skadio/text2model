include "globals.mzn";

% Data (embedded as requested)
int: maxTotal = 100;
int: maxX = 70;
int: maxY = 50;

int: costX = 50;
int: costY = 80;

% Decision variables (whole numbers only)
var 0..maxX: x;  % number of package X sold
var 0..maxY: y;  % number of package Y sold

% Constraints
constraint x + y <= maxTotal;

% x must be at least 10 more than twice y: x >= 2y + 10
constraint x >= 2 * y + 10;

% | y - floor(x/2) | <= 20  (half of x rounded down)
var 0..(maxX div 2): halfx_floor;
constraint halfx_floor = x div 2;
constraint abs(y - halfx_floor) <= 20;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];