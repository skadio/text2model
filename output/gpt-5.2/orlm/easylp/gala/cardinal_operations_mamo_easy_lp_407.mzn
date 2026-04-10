% Shipping fleet allocation - minimize total cost
include "globals.mzn";

% Data (embedded as required)
set of int: R = 1..4;
array[R] of int: cost = [4, 5, 6, 7]; % X1..X4

% Decision variables: number of trucks on each route (nonnegative integers)
array[R] of var 0..1000: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint x[1] + x[2] <= 50;
constraint x[3] + x[4] <= 80;
constraint x[1] + x[3] >= 30;
constraint x[2] + x[4] >= 40;

% Objective: minimize total cost
var int: total_cost = sum(r in R)(cost[r] * x[r]);
solve minimize total_cost;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Minimum total cost (nearest whole unit): ", show(total_cost), "\n"
];