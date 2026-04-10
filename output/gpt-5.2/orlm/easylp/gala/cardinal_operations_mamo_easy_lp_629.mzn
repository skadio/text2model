include "globals.mzn";

% Data (embedded as required)
int: c1 = 5000;
int: c2 = 6000;
int: c3 = 7000;
int: c4 = 8000;

int: x1_min = 0;  int: x1_max = 20;
int: x2_min = 0;  int: x2_max = 20;
int: x3_min = 0;  int: x3_max = 15;
int: x4_min = 0;  int: x4_max = 15;

% Decision variables: number of employees per department
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

% Constraints
constraint x1 + x2 <= 40;
constraint x3 + x4 <= 30;
constraint x1 >= x3 + 10;
constraint x2 >= x4 + 5;

% Objective: minimize total payroll cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total payroll cost = $", show(total_cost), "\n"
];