int: c1 = 50;
int: c2 = 30;
int: c3 = 70;
int: c4 = 60;

int: ub1 = 1000;
int: ub2 = 1200;
int: ub3 = 800;
int: ub4 = 700;

var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Combined allocation limits
constraint x1 + x2 <= 2000;
constraint x3 + x4 <= 1500;

% Balance constraint:
% (1/2)*x1 >= (1/3)*x2 + 500  ->  3*x1 - 2*x2 >= 3000
constraint 3*x1 - 2*x2 >= 3000;

% Strategic importance: x4 at least 100 more than x3
constraint x4 >= x3 + 100;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];