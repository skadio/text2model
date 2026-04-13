% Military logistics resource allocation (integer linear optimization)
include "globals.mzn";

% Data (embedded from description)
int: costX = 50;      % support points per unit X
int: costY = 75;      % support points per unit Y

int: a1 = 2; int: b1 = 1; int: rhs1 = 60;   % 2X + 1Y >= 60
int: a2 = 1; int: b2 = 3; int: rhs2 = 120;  % 1X + 3Y <= 120

% Variable bounds derived from constraints (safe, finite)
int: Xmax = rhs2;                 % since X + 3Y <= 120 and Y>=0, X <= 120
int: Ymax = rhs2 div 3;           % Y <= 40

var 0..Xmax: X;
var 0..Ymax: Y;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;

% Objective: minimize total support points
var 0..(costX*Xmax + costY*Ymax): total_support = costX * X + costY * Y;
solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];