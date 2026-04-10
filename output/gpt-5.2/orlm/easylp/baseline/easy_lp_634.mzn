% Tourism agency resource allocation (integer) - minimize total cost

int: c1 = 200;
int: c2 = 150;
int: c3 = 100;
int: c4 = 50;

% Decision variables: resource allocations (whole numbers, nonnegative)
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

% Constraints
constraint x1 + x2 <= 300;
constraint x3 + x4 <= 200;
constraint x1 + x3 >= 150;
constraint x2 + x4 >= 150;

% Objective: minimize total promotion cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];