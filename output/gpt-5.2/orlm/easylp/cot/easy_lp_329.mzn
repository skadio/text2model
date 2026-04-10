% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: UB = 1000; % explicit embedded upper bound to keep variables bounded

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + x3 >= 150;
constraint x2 - 3*x4 <= 50;
constraint x3 - x4 >= 20;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];