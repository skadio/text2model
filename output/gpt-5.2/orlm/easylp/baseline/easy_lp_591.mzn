int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

int: max1 = 600;
int: max2 = 400;
int: max3 = 500;
int: max4 = 300;

var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

constraint x1 + x2 <= 1000;
constraint 2 * x3 + 3 * x4 <= 1200;
constraint x1 + x2 + x3 + x4 >= 500;
constraint 2 * x1 > x3;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];