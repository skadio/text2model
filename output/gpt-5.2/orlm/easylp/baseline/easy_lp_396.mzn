% Resource allocation optimization for four environmental projects

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Decision variables: whole-number allocations (nonnegative)
var 0..2000: x1;
var 0..2000: x2;
var 0..2000: x3;
var 0..2000: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + x4 >= 500;
constraint x1 + 3*x4 <= 1200;
constraint x2 - 2*x3 <= 300;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];