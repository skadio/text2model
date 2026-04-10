% Fleet allocation: minimize daily operating cost

int: costX = 4;
int: costY = 5;

% Constraints:
% 2X + 3Y <= 1000
% 3X + 2Y >= 800
% X, Y are nonnegative integers

% Variable bounds derived from constraints
var 0..500: X;  % from 2X <= 1000
var 0..333: Y;  % from 3Y <= 1000

constraint 2*X + 3*Y <= 1000;
constraint 3*X + 2*Y >= 800;

var int: total_cost = costX*X + costY*Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_daily_cost = $", show(total_cost), "\n"
];