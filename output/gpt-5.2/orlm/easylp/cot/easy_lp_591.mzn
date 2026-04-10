% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: unit_cost = [50, 60, 70, 80];
array[P] of int: max_cap   = [600, 400, 500, 300];

% Variables
array[P] of var 0..600: x; % temporary uniform upper bound; refined by constraints below
var int: total_cost;

% Constraints
constraint forall(i in P) (x[i] >= 0);
constraint forall(i in P) (x[i] <= max_cap[i]);

% Supply / demand constraints
constraint x[1] + x[2] <= 1000;
constraint 2 * x[3] + 3 * x[4] <= 1200;
constraint x[1] + x[2] + x[3] + x[4] >= 500;

% Balance constraint: x1 exceeds half of x3
% x1 > x3/2  <=>  2*x1 > x3  <=>  2*x1 >= x3 + 1 (integers)
constraint 2 * x[1] >= x[3] + 1;

% Cost definition
constraint total_cost = sum(i in P)(unit_cost[i] * x[i]);

% Objective
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];