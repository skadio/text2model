int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;
int: cost4 = 5;

int: cap12 = 500;
int: cap34 = 600;
int: min13 = 300;
int: min24 = 400;

int: ub1 = 300;
int: ub2 = 200;
int: ub3 = 300;
int: ub4 = 400;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];