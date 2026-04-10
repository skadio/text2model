include "globals.mzn";

% Data (embedded from problem statement)
int: maxTotal = 5000;

int: costX = 5;
int: costY = 10;
int: costZ = 20;

% Decision variables: whole-number order quantities
var 0..maxTotal: x;  % units of product X
var 0..maxTotal: y;  % units of product Y
var 0..maxTotal: z;  % units of product Z

% Constraints
constraint x + y + z <= maxTotal;

% X must be at least 1000 more than half of Y:
% x >= y/2 + 1000  <=>  2x >= y + 2000
constraint 2 * x >= y + 2000;

% Z should not exceed 75% of X by more than 1500:
% z <= 0.75x + 1500  <=>  4z <= 3x + 6000
constraint 4 * z <= 3 * x + 6000;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];