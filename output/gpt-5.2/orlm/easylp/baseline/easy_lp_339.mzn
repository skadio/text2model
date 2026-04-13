% Resource allocation / production planning (all data embedded)

int: cap12 = 5000;
int: cap34 = 2000;

int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 20;

var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint 2*x1 + 4*x2 >= x3;
constraint x2 + 3*x4 - x1 >= 100;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];