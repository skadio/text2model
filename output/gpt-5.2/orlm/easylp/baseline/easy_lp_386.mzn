% Tourism agency resource allocation (all data embedded)

int: cost1 = 50;
int: cost2 = 100;
int: cost3 = 70;
int: cost4 = 120;

int: max12 = 500;
int: max34 = 300;

int: rhs12 = 400;  % 2*x1 + 4*x2 >= 400
int: rhs34 = 250;  % 3*x3 + 2*x4 >= 250

var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint 2*x1 + 4*x2 >= rhs12;
constraint 3*x3 + 2*x4 >= rhs34;

var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];