include "globals.mzn";

% Data (embedded as requested)
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;

int: x1_max = 10000;
int: x2_max = 8000;
int: x3_max = 6000;

% Decision variables (integer allocations)
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

% Constraints
constraint 5*x1 + 7*x2 + 9*x3 >= 5000;

% "must not exceed 1500" interpreted as an upper bound on the expression
constraint 3*x2 - x1 - 4*x3 <= 1500;

% x1 - x3 - 2.5*x2 == 2000  ->  2*x1 - 2*x3 - 5*x2 == 4000 (avoid fractions)
constraint 2*x1 - 2*x3 - 5*x2 = 4000;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];