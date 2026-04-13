include "globals.mzn";

/*
  Tourism resource allocation with integer units.
  Decision variables xi = number of promotion units allocated to destination i.
  Costs per unit: x1=200, x2=150, x3=100, x4=50.
*/

% Data (embedded as required)
array[1..4] of int: cost = [200, 150, 100, 50];

% Decision variables (nonnegative integers)
array[1..4] of var int: x;
constraint forall(i in 1..4)(x[i] >= 0);

% Constraints
constraint x[1] + x[2] <= 300;
constraint x[3] + x[4] <= 200;
constraint x[1] + x[3] >= 150;
constraint x[2] + x[4] >= 150;

% Objective: minimize total cost
var int: total_cost = sum(i in 1..4)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "total_cost = ", show(total_cost), "\n"
];