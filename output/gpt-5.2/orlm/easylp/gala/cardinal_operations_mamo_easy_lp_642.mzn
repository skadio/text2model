include "globals.mzn";

% Data (embedded as required)
int: max_x1 = 300;
int: max_x2 = 500;
int: max_x3 = 2000;
int: max_x4 = 30;

int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Decision variables (whole-number resource units)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + 3*x3 >= 2000;

% "Difference ... must not exceed" interpreted as absolute difference
% Note: x4/2 may be fractional; multiply by 2 to keep integrality exact.
constraint abs(2*x2 - x4) <= 1000;

constraint abs(x1 - (x2 + x3)) <= 70;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_3dp=", show_float(fix(total_cost) / 1.0), "\n"
];