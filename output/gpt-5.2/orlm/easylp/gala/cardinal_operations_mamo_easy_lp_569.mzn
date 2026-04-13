% Environmental projects resource allocation (integer linear optimization)

include "globals.mzn";

% Data (embedded as requested)
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: rhs1 = 1000;   % x1 + 2*x2 <= 1000
int: rhs2 = 600;    % x2 + 3*x3 >= 600
int: rhs3 = 500;    % 2*x3 - x1 = 500

% Decision variables (whole numbers, nonnegative)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;

% Constraints
constraint x1 + 2*x2 <= rhs1;
constraint x2 + 3*x3 >= rhs2;
constraint 2*x3 - x1 = rhs3;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];