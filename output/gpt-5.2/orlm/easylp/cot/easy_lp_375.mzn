% Parameters (with values embedded)
int: n = 4;
set of int: D = 1..n;

array[D] of int: cost = [50, 70, 90, 110];

int: ub_x1 = 20;
int: ub_x2 = 15;
int: ub_x3 = 10;
int: ub_x4 = 5;

int: lim_12 = 40;
int: lim_23 = 30;
int: lim_34 = 20;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Constraints
constraint x1 + x2 <= lim_12;
constraint x2 + x3 <= lim_23;
constraint x3 + x4 <= lim_34;

constraint x1 >= (x4 div 2) + 10;

% Objective
var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];