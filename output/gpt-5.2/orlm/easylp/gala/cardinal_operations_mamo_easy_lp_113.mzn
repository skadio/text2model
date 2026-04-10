% Sports training camp drill scheduling (integer optimization)
% Minimize fatigue: 2*X + 3*Y
% Subject to:
%   X + Y <= 40
%   2*X + Y >= 30
%   X, Y are nonnegative integers

int: max_total_drills = 40;
int: min_balance = 30;

var 0..max_total_drills: X;
var 0..max_total_drills: Y;

constraint X + Y <= max_total_drills;
constraint 2 * X + Y >= min_balance;

var int: fatigue = 2 * X + 3 * Y;

solve minimize fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum fatigue (rounded) = ", show(fatigue), "\n"
];