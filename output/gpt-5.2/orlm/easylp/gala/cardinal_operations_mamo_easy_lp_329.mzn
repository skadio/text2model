% Marketing budget allocation optimization (all data embedded)

% Decision variables (integer allocations in dollars)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Bounds (not explicitly given in the statement; use safe nonnegative bounds)
% Upper bounds chosen large enough to not cut off any optimal solution.
constraint x1 >= 0 /\ x1 <= 1000;
constraint x2 >= 0 /\ x2 <= 1000;
constraint x3 >= 0 /\ x3 <= 1000;
constraint x4 >= 0 /\ x4 <= 1000;

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + x3 >= 150;
constraint x2 - 3*x4 <= 50;
constraint x3 - x4 >= 20;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 5*x3 + 4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];