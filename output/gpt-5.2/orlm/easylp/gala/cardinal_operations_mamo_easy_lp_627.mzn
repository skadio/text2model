include "globals.mzn";

% Decision variables: number of employees in each department (integers)
var 0..30: x1;  % Department X1 capacity <= 30
var 0..40: x2;  % Department X2 capacity <= 40
var 0..50: x3;  % Department X3 capacity <= 50
var 0..60: x4;  % Department X4 capacity <= 60

% Staffing requirements
constraint x1 + x2 >= 10;
constraint x3 + x4 <= 20;

% Difference constraints
constraint 2*x2 - x1 - x3 >= 5;
constraint x4 - x1 - x2 >= 5;

% Cost parameters (in dollars per employee)
int: c1 = 5000;
int: c2 = 4000;
int: c3 = 6000;
int: c4 = 7000;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];