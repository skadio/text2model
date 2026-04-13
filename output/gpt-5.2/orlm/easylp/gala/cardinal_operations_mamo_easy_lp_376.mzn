include "globals.mzn";

% Data embedded from the problem description
float: cX = 1.5;
float: cY = 2.0;
float: cZ = 3.0;
float: cW = 4.0;

int: maxXY = 50;
int: minX  = 20;
int: maxY  = 30;

% Decision variables (indivisible employees)
var 0..100: X;
var 0..100: Y;
var 0..100: Z;
var 0..100: W;

% Constraints
constraint X + Y <= maxXY;
constraint X >= minX;
constraint Y <= maxY;
constraint Z + W - X <= 0;      % i.e., Z + W <= X

% Objective: minimize total cost
var float: totalCost = cX*X + cY*Y + cZ*Z + cW*W;

solve minimize totalCost;

% Rounded to nearest whole number in output
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "W = ", show(W), "\n",
  "TotalCost = ", show(totalCost), "\n",
  "RoundedTotalCost = ", show(round(totalCost)), "\n"
];