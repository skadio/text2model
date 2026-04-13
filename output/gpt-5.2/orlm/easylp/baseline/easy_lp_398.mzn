% Environmental agency resource allocation (all data embedded)

int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

% Upper bounds (chosen sufficiently large given constraints)
int: ub1 = 100;
int: ub2 = 100;
int: ub3 = 200;
int: ub4 = 200;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;
constraint 2*x1 + 3*x2 - x3 <= 0;
constraint 4*x3 - 2*x2 = 5*x4;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];