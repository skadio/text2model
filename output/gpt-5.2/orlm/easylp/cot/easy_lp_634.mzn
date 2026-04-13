% Parameters (with values embedded)
int: N = 4;
set of int: D = 1..N;

array[D] of int: cost = [200, 150, 100, 50];

int: max12 = 300;
int: max34 = 200;
int: min13 = 150;
int: min24 = 150;

% Variables
array[D] of var 0..300: x;  % resource allocations (whole numbers)

% Constraints
constraint x[1] + x[2] <= max12;
constraint x[3] + x[4] <= max34;

constraint x[1] + x[3] >= min13;
constraint x[2] + x[4] >= min24;

% Objective
var int: total_cost = sum(i in D)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "min_total_cost=", show(total_cost), "\n"
];