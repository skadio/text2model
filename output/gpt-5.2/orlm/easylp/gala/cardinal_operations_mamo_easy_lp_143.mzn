% Resource allocation between units X and Y (integers)
% Minimize total support points: 5*X + 3*Y
% Constraints:
%   2*X + Y >= 10
%   X + 4*Y <= 50

include "globals.mzn";

% Decision variables (nonnegative integers)
var 0..100: X;
var 0..100: Y;

% Constraints
constraint 2 * X + Y >= 10;
constraint X + 4 * Y <= 50;

% Objective: minimize support points (already integer, so rounding is inherent)
var int: total_support = 5 * X + 3 * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];