% Real estate resource allocation optimization (all data embedded)

include "globals.mzn";

% Decision variables: whole-number resource units
var 0..1000: X;  % residential
var 0..1000: Y;  % commercial
var 0..1000: Z;  % industrial

% Constraints
constraint X + Y + Z <= 1000;
constraint X >= Y + 50;          % residential exceeds commercial by at least 50
constraint abs(Z - X) <= 200;    % industrial and residential differ by at most 200
constraint Y >= Z + 30;          % commercial at least 30 more than industrial

% Cost per unit
int: cX = 200;
int: cY = 150;
int: cZ = 300;

var int: totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Z (industrial)  = ", show(Z), "\n",
  "Total cost ($)  = ", show(totalCost), "\n"
];