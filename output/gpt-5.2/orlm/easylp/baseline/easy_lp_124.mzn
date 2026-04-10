% Resource allocation for two programs with integer decisions

int: costX = 5;
int: costY = 3;

% Constraints:
% 2*X + 4*Y >= 50
% 3*X + 1*Y <= 30
% X, Y are whole numbers (nonnegative)

var 0..100: X;
var 0..100: Y;

constraint 2*X + 4*Y >= 50;
constraint 3*X + Y <= 30;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total resources (cost) = ", show(total_cost), "\n"
];