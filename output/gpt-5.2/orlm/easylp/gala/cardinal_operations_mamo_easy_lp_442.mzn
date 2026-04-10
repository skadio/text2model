% Budget allocation between departments X and Y
% All data embedded as requested.

include "globals.mzn";

% Parameters
int: maxTotalBudget = 1000;
int: minEffectiveness = 500;
int: maxDiff = 300;

int: costX = 5;   % $ per budget dollar for X
int: costY = 3;   % $ per budget dollar for Y

% Decision variables (whole dollars)
var 0..maxTotalBudget: x;  % budget for department X
var 0..maxTotalBudget: y;  % budget for department Y

% Constraints
constraint x + y <= maxTotalBudget;
constraint 2 * x + y >= minEffectiveness;
constraint abs(x - y) <= maxDiff;

% Objective: minimize total cost
var 0..(costX*maxTotalBudget + costY*maxTotalBudget): totalCost;
constraint totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];