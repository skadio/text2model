% Manufacturing production planning: minimize cost with linear constraints
% Data embedded as requested.

int: costX = 5;
int: costY = 10;

int: a1 = 2;  % resource/labor constraint coefficients
int: b1 = 3;
int: cap1 = 100;

int: a2 = 4;  % demand constraint coefficients
int: b2 = 1;
int: min2 = 50;

% Decision variables: whole-number units produced
var 0..cap1 div a1: x;  % upper bound from 2x <= 100
var 0..cap1 div b1: y;  % upper bound from 3y <= 100

% Constraints
constraint a1 * x + b1 * y <= cap1;
constraint a2 * x + b2 * y >= min2;

% Objective: minimize total production cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];