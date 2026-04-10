include "globals.mzn";

% Decision variables: integer production quantities
var 0..5000: x1;
var 0..5000: x2;
var 0..2000: x3;
var 0..2000: x4;

% Capacity constraints
constraint x1 + x2 <= 5000;
constraint x3 + x4 <= 2000;

% Production/relationship constraints
constraint 2 * x1 + 4 * x2 >= x3;
constraint x2 + 3 * x4 - x1 >= 100;

% Costs
int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 20;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];