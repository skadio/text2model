include "globals.mzn";

% Data (embedded as required)
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxTotal = 50;
int: maxX = 20;
int: maxY = 30;
int: maxZ = 25;

int: minXminusY = 10;   % X >= Y + 10
int: maxYplusZ = 40;    % Y + Z <= 40

% Decision variables: number of vehicles of each type (whole numbers)
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y + Z <= maxTotal;
constraint X >= Y + minXminusY;
constraint Y + Z <= maxYplusZ;

% Objective: minimize daily operating cost
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum daily operating cost ($) = ", show(totalCost), "\n"
];