int: max_x1 = 100;
int: max_x2 = 100;
int: max_x3 = 100;
int: max_x4 = 100;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Minimize total cost: 5, 7, 3, 4 units respectively
var int: total_cost = 5*x1 + 7*x2 + 3*x3 + 4*x4;

constraint
  % 2*x1 + x2 - 0.5*x3 <= 50  ==>  4*x1 + 2*x2 - x3 <= 100
  4*x1 + 2*x2 - x3 <= 100;

constraint
  % x1 + 2.5*x2 - x4 >= 30  ==>  2*x1 + 5*x2 - 2*x4 >= 60
  2*x1 + 5*x2 - 2*x4 >= 60;

constraint
  % -0.75*x1 + x3 + x4 <= 20  ==>  -3*x1 + 4*x3 + 4*x4 <= 80
  -3*x1 + 4*x3 + 4*x4 <= 80;

constraint
  % -x1 - x2 + 0.6*x4 >= 10  ==>  -5*x1 - 5*x2 + 3*x4 >= 50
  -5*x1 - 5*x2 + 3*x4 >= 50;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];