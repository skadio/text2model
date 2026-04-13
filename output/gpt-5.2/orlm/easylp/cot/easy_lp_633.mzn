% Parameters (with values embedded)
int: n = 4;
set of int: DEPTS = 1..n;

% Cost coefficients for x1..x4
array[DEPTS] of int: cost = [4, 3, 5, 6];

% Variable bounds
array[DEPTS] of int: lb = [0, 0, 0, 0];
array[DEPTS] of int: ub = [30, 20, 40, 50];

% Variables
array[DEPTS] of var int: x;

% Constraints
constraint forall(i in DEPTS) (lb[i] <= x[i] /\ x[i] <= ub[i]);

% x1 + 2*x2 >= 10
constraint x[1] + 2 * x[2] >= 10;

% 2*x3 - x4 <= 15
constraint 2 * x[3] - x[4] <= 15;

% x1 + x3 - 3*x2 = 8
constraint x[1] + x[3] - 3 * x[2] = 8;

% x1 - (x2 + x4) <= 25
constraint x[1] - x[2] - x[4] <= 25;

% Objective
var int: total_cost = sum(i in DEPTS)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];