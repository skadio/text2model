% School district funding allocation (integer linear optimization)
include "globals.mzn";

% Decision variables: dollars allocated to each program
var 0..600: X;
var 0..400: Y;
var 0..300: Z;

% Constraints
constraint X + Y + Z <= 1000;      % total budget cap
constraint 2*X + Y >= 400;         % objective requirement 1
constraint Y + Z >= 500;           % objective requirement 2

% Cost/benefit coefficients (interpreted as per-dollar cost)
int: costX = 5;
int: costY = 3;
int: costZ = 1;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];