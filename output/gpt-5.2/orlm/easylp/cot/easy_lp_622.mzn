% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max12 = 1000;
int: max34 = 800;

int: ub1 = 500;
int: ub2 = 600;
int: ub3 = 400;
int: ub4 = 300;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% 0.5*x1 - 0.6*x2 >= 50  ==>  5*x1 - 6*x2 >= 500
constraint 5*x1 - 6*x2 >= 500;

% 0.7*x3 - x4 <= 70  ==>  7*x3 - 10*x4 <= 700
constraint 7*x3 - 10*x4 <= 700;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];