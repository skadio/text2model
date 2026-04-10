int: c1 = 5000;
int: c2 = 3000;
int: c3 = 4000;
int: c4 = 2000;

var 0..3000: x1;
var 0..2500: x2;
var 0..1500: x3;
var 0..300:  x4;

constraint x1 + x2 + x3 + x4 <= 10000;

% 5*x1 >= 2000 + 3.5*x2  -> multiply by 2
constraint 10*x1 >= 4000 + 7*x2;

% 4.7*x4 <= x3 + 3500 -> multiply by 10
constraint 47*x4 <= 10*x3 + 35000;

% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000 -> multiply by 2
constraint 2*x2 + 7*x3 + 2*x4 - 5*x1 >= 2000;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];