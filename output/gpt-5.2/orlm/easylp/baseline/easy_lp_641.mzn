int: c1 = 100;
int: c2 = 150;
int: c3 = 80;
int: c4 = 50;

% Bounds not specified in the description; use a safe nonnegative range.
int: U = 100000;

var 0..U: x1;
var 0..U: x2;
var 0..U: x3;
var 0..U: x4;

% Constraints:
constraint 3*x1 + 2*x2 - x3 <= 5000;
constraint -x1 + 4*x2 + x4 >= 2000;
constraint -x1 - x2 + 5*x3 - x4 = 4000;

% 6*x2 + 7.5*x3 - 8.5*x4 - x1 <= 3000
% Multiply by 2 to keep integrality:
constraint 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];