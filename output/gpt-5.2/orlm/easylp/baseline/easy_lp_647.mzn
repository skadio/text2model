% Resource allocation MILP (all data embedded)

int: n = 4;
set of int: UNITS = 1..n;

array[UNITS] of int: cost = [300, 200, 500, 400]; % x1,x2,x3,x4

% Decision variables: integer resource allocations
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Operational constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + x3 >= 800;
constraint 2*x2 - x4 >= 600;                 % x2 - 0.5*x4 >= 300  -> 2*x2 - x4 >= 600
constraint x2 - x3 - x1 <= 70;

% Bounds (implied by "within specified bounds"; ensure nonnegative allocations)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Objective: minimize total cost
var int: total_cost = 300*x1 + 200*x2 + 500*x3 + 400*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];