% Parameters (with values embedded)
int: n = 4;
set of int: DEPTS = 1..n;

array[DEPTS] of int: cost = [100, 50, 30, 200];

% Explicit bounds (not provided numerically in the description; use non-negative as a safe policy bound)
int: LB = 0;
int: UB = 1000; % sufficiently large upper bound to keep variables bounded

% Variables
array[DEPTS] of var int: x;

% Constraints
constraint forall(i in DEPTS)(x[i] >= LB /\ x[i] <= UB);

% x1 + x2 >= 10
constraint x[1] + x[2] >= 10;

% x3 + x4 >= 20
constraint x[3] + x[4] >= 20;

% 5*x1 - 2*x2 <= 0
constraint 5*x[1] - 2*x[2] <= 0;

% 3*x3 - x4 >= 0
constraint 3*x[3] - x[4] >= 0;

% Objective
var int: total_cost = sum(i in DEPTS)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];