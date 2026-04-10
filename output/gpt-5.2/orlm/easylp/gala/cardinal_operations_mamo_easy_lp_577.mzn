% Shipping fleet allocation: minimize cost under linear constraints
include "globals.mzn";

% Decision variables (whole trucks)
var 0..100: X;  % trucks on route X
var 0..120: Y;  % trucks on route Y
var 0..90:  Z;  % trucks on route Z

% Constraints
constraint X + Y <= 200;
constraint Y + Z >= 150;
constraint abs(X - Z) = 30;

% Costs
int: costX = 5;
int: costY = 4;
int: costZ = 3;

var 0..100000: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];