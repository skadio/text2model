% Parameters (with values embedded)
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

int: x1_lb = 0;  int: x1_ub = 100;
int: x2_lb = 0;  int: x2_ub = 80;
int: x3_lb = 0;  int: x3_ub = 60;
int: x4_lb = 0;  int: x4_ub = 70;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + 2*x2 <= 50;
constraint 3*x3 - x4 >= 20;
constraint x2 + x3 - x1 <= 30;
constraint 3*x4 - x2 >= 10;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];