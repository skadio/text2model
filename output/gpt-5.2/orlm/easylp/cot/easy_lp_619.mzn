% Parameters (with values embedded)
int: n = 4;
set of int: TASKS = 1..n;

int: maxX1 = 10;
int: maxX2 = 15;
int: maxX3 = 20;
int: maxX4 = 25;

array[TASKS] of int: cost = [10, 20, 30, 40];

% Variables
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;
var 0..maxX4: X4;

% Constraints
constraint X1 + X2 <= 8;
constraint X2 + X3 <= 12;
constraint X3 + X4 >= 14;

% Twice X2 minus X1 and X3 should not surpass -6: 2*X2 - X1 - X3 <= -6
constraint 2 * X2 - X1 - X3 <= -6;

% x3 - (1/2)x4 >= x2  ->  2*x3 - x4 >= 2*x2
constraint 2 * X3 - X4 >= 2 * X2;

% Objective
var int: total_cost = cost[1]*X1 + cost[2]*X2 + cost[3]*X3 + cost[4]*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "total_cost=$", show(total_cost), "\n"
];