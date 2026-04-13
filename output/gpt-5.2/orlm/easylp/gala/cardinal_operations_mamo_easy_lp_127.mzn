% Resource allocation between two programs X and Y
% Minimize total benefit score: 4*X + 3*Y
% Subject to:
%   2*X + Y >= 10
%   X + 3*Y <= 30
%   X, Y are nonnegative integers

int: minImpact = 10;
int: budgetCap = 30;

var 0..budgetCap: X;
var 0..budgetCap: Y;

constraint 2 * X + Y >= minImpact;
constraint X + 3 * Y <= budgetCap;

var int: totalBenefit = 4 * X + 3 * Y;

solve minimize totalBenefit;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total benefit score (rounded) = ", show(totalBenefit), "\n"
];