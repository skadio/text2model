% Tourism tours planning: minimize cost with integer tours for group types X and Y

include "globals.mzn";

% Parameters (embedded from problem statement)
int: maxTotal = 20;
int: minMix   = 10;   % 2*X + Y >= 10
int: maxDiff  = 5;

int: maxX = 15;
int: maxY = 10;

int: costX = 100;
int: costY = 50;

% Decision variables
var 0..maxX: x;  % number of tours for group type X
var 0..maxY: y;  % number of tours for group type Y

% Constraints
constraint x + y <= maxTotal;
constraint 2*x + y >= minMix;
constraint abs(x - y) <= maxDiff;

% Objective
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];