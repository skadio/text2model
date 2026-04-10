% HR allocation problem - embedded data

int: c1 = 50;
int: c2 = 70;
int: c3 = 90;
int: c4 = 110;

int: ub1 = 20;
int: ub2 = 15;
int: ub3 = 10;
int: ub4 = 5;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

constraint x1 + x2 <= 40;
constraint x2 + x3 <= 30;
constraint x3 + x4 <= 20;
constraint x1 >= (x4 div 2) + 10;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];