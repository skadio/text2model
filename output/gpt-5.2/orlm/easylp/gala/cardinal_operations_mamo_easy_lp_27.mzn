% Fleet cost minimization (integer linear optimization)
include "globals.mzn";

% Data (embedded as required)
int: costX = 4;
int: costY = 5;

int: cap = 1000;      % 2*X + 3*Y <= 1000
int: demand = 800;    % 3*X + 2*Y >= 800

% Decision variables (nonnegative integers)
% Upper bounds derived from constraints to keep domains finite:
% From 2X+3Y<=1000 => X<=500, Y<=333
var 0..500: X;
var 0..333: Y;

% Constraints
constraint 2*X + 3*Y <= cap;
constraint 3*X + 2*Y >= demand;

% Objective
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum daily cost ($) = ", show(totalCost), "\n"
];