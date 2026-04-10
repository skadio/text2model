% Military logistics resource distribution (integer units)
% Minimize total support points: 50*X + 75*Y
% Constraints:
%   2*X + 1*Y >= 60
%   1*X + 3*Y <= 120
%   X, Y are nonnegative integers (indivisible units)

int: supportX = 50;
int: supportY = 75;

var 0..1000: X;
var 0..1000: Y;

constraint 2*X + Y >= 60;
constraint X + 3*Y <= 120;

var int: totalSupport = supportX * X + supportY * Y;

solve minimize totalSupport;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "minimum_total_support_points=", show(totalSupport), "\n",
  "rounded_minimum_total_support_points=", show(totalSupport), "\n"
];