include "globals.mzn";

% Data (embedded as requested)
int: BUDGET = 1000;
int: cX = 4;
int: cY = 3;

% Decision variables (whole number allocations)
var 0..BUDGET: x;   % resources for campaign X
var 0..BUDGET: y;   % resources for campaign Y

% Constraints
constraint x + y <= BUDGET;
constraint x >= 2 * y + 300;

% Objective: minimize total cost
var 0..(cX*BUDGET + cY*BUDGET): totalCost = cX * x + cY * y;
solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];