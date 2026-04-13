int: c1 = 300;
int: c2 = 200;
int: c3 = 100;
int: c4 = 50;

% Use integer variables; multiply constraints by 2 to eliminate halves.
var int: x1;
var int: x2;
var int: x3;
var int: x4;

constraint x1 + x2 <= 500;

% 2*x1 + 3.5*x3 >= 700  ->  4*x1 + 7*x3 >= 1400
constraint 4*x1 + 7*x3 >= 1400;

% x2 - 0.5*x3 - x1 <= 300  ->  2*x2 - x3 - 2*x1 <= 600
constraint 2*x2 - x3 - 2*x1 <= 600;

% 0.5*x4 - x2 <= 400  ->  x4 - 2*x2 <= 800
constraint x4 - 2*x2 <= 800;

% x4 <= x1 - 150
constraint x4 <= x1 - 150;

% Nonnegativity (resource allocations)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];