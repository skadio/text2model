int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 8;

int: ub1 = 500;
int: ub2 = 400;
int: ub3 = 300;
int: ub4 = 200;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

constraint x1 + 2*x2 <= 1500;
constraint 3*x1 + x3 >= 1000;
constraint 4*x4 - x2 <= 600;
constraint -x1 + x2 + x3 + x4 = -200;  % x2 + x3 + x4 - x1 results in a deficit of 200

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];