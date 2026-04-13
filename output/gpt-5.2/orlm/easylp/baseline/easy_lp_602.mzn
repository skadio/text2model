% Resource allocation across four departments
% Minimize total operating cost with integer allocations.

int: MAX_ALLOC = 2000;

var 0..MAX_ALLOC: x1;
var 0..MAX_ALLOC: x2;
var 0..MAX_ALLOC: x3;
var 0..MAX_ALLOC: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + 3*x2 >= 500;
constraint abs(x3 - x1) <= 200;
constraint x4 >= x2 + 150;

% Objective: minimize total operating cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_operating_cost=", show(total_cost), "\n"
];