% Resource allocation between departments X and Y
% All data embedded as requested.

include "globals.mzn";

% Parameters
int: budgetMax = 100;
int: utilX = 5;
int: utilY = 3;

int: serviceMin = 30;
int: serviceX = 2;
int: serviceY = 1;

int: balanceMaxDiff = 10;

int: costX = 10;
int: costY = 20;

% Decision variables (whole numbers, nonnegative)
var 0..budgetMax: x;   % allocation to department X
var 0..budgetMax: y;   % allocation to department Y

% Constraints
constraint utilX * x + utilY * y <= budgetMax;
constraint serviceX * x + serviceY * y >= serviceMin;
constraint abs(x - y) <= balanceMaxDiff;

% Objective
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];