int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: limit1 = 1000;
int: rhs2 = 600;
int: diff_val = 500;

var 0..limit1: x1;
var 0..limit1: x2;
var 0..limit1: x3;

constraint x1 + 2 * x2 <= limit1;
constraint x2 + 3 * x3 >= rhs2;
constraint 2 * x3 - x1 = diff_val;

var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];