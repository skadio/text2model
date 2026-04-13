% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [200, 300, 400, 500];

int: cap_x1_x2 = 1000;
int: cap_2x3_x4 = 1200;
int: min_total_alloc = 500;

% Variables
array[P] of var 0..100000: x;  % whole-number allocations (nonnegative, large upper bound)

% Constraints
constraint x[1] + x[2] <= cap_x1_x2;
constraint 2 * x[3] + x[4] <= cap_2x3_x4;
constraint x[1] + x[2] + x[3] + x[4] >= min_total_alloc;

% Objective
var int: total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];