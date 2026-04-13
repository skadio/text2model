include "globals.mzn";

% Data (embedded as required)
int: n = 4;
array[1..n] of int: cost = [5, 7, 3, 4];         % x1..x4 costs
array[1..n] of int: ub   = [40, 50, 30, 20];     % upper bounds
int: budgetMax = 100;

% Decision variables: investments must be whole numbers
array[1..n] of var 0..max(ub): x;
constraint forall(i in 1..n)(x[i] <= ub[i]);

% Constraints
constraint sum(i in 1..n)(x[i]) <= budgetMax;

% Diversification constraint:
% x1 + 4*x2 + x3 + 2*x4 >= 50
constraint x[1] + 4*x[2] + x[3] + 2*x[4] >= 50;

% Market constraint:
% 3*x1 + x2 + 2*x3 + x4 = 75
constraint 3*x[1] + x[2] + 2*x[3] + x[4] = 75;

% Objective: minimize total cost
var int: total_cost = sum(i in 1..n)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "x1(residential) = ", show(x[1]), "\n",
  "x2(commercial)  = ", show(x[2]), "\n",
  "x3(industrial)  = ", show(x[3]), "\n",
  "x4(recreational)= ", show(x[4]), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];