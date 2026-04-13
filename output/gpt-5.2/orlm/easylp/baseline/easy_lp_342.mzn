% Fleet allocation MILP (integer) - all data embedded

int: c1 = 10;
int: c2 = 9;
int: c3 = 11;
int: c4 = 12;

% Route bounds (not specified numerically in the description; assume nonnegative)
int: LB = 0;
int: UB = 10000;

var LB..UB: x1;
var LB..UB: x2;
var LB..UB: x3;
var LB..UB: x4;

constraint x1 + x2 <= 500;
constraint x3 + x4 <= 400;
constraint x1 + x3 >= 300;
constraint x2 + x4 >= 600;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];