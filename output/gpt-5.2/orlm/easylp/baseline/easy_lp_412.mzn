int: c1 = 200;
int: c2 = 300;
int: c3 = 400;
int: c4 = 500;

% Bounds (not specified in the description; using nonnegative integer allocations)
int: lb = 0;
int: ub = 1000000;

var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;
var lb..ub: x4;

constraint x1 + x2 <= 1000;
constraint 2*x3 + x4 <= 1200;
constraint x1 + x2 + x3 + x4 >= 500;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];