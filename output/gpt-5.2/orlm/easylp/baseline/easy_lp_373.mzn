int: max12 = 500;
int: max34 = 400;

int: mind13 = 350;
int: mind24 = 300;

array[1..4] of int: cost = [10, 15, 20, 25];

var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint x1 + x3 >= mind13;
constraint x2 + x4 >= mind24;

var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];