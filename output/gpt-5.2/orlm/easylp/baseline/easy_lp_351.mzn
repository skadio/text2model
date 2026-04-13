% Healthcare resource allocation (all data embedded)

int: n = 4;
set of int: DEPTS = 1..n;

% Decision variables: allocations to departments x1..x4 (integers)
% Bounds (not specified in the description): use nonnegative allocations.
array[DEPTS] of var int: x;
constraint forall(i in DEPTS)(x[i] >= 0);

% Costs for x1, x2, x3, x4
array[DEPTS] of int: cost = [100, 50, 30, 200];

% Constraints
constraint x[1] + x[2] >= 10;          % x1 + x2 >= 10
constraint x[3] + x[4] >= 20;          % x3 + x4 >= 20
constraint 5*x[1] - 2*x[2] <= 0;       % 5x1 - 2x2 <= 0
constraint 3*x[3] - x[4] >= 0;         % 3x3 - x4 >= 0

% Objective: minimize total cost
var int: total_cost = sum(i in DEPTS)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];