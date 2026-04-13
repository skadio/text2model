% Resource allocation between two unit types X and Y
% Minimize total support points: 4*X + 5*Y
% Subject to:
%   3*X + 2*Y <= 50
%   X + Y >= 10
%   X, Y are whole numbers (nonnegative integers)

var 0..50: X;
var 0..50: Y;

constraint 3 * X + 2 * Y <= 50;
constraint X + Y >= 10;

var int: total_support = 4 * X + 5 * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];