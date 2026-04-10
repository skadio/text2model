include "globals.mzn";

% ---- Data (embedded; none provided separately) ----
int: nProjects = 4;
set of int: P = 1..nProjects;

% Project order: 1=X1, 2=X2, 3=X3, 4=X4
array[P] of int: cost = [4, 2, 3, 5];

% NOTE: The statement mentions "each resource has specific bounds" but no numeric bounds are given.
% To keep the model runnable, we assume nonnegative integer allocations and add safe upper bounds.
int: UB = 100000; % sufficiently large to avoid cutting feasible optimum in typical cases

% ---- Decision variables ----
array[P] of var 0..UB: x;  % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% ---- Constraints ----
% Use integer-safe formulations by multiplying to avoid decimals.

% |0.5*X2 - X1| <= 100  =>  |X2 - 2*X1| <= 200
constraint abs(x[2] - 2*x[1]) <= 200;

% X1 >= 0.7*X3 + 200  =>  10*X1 >= 7*X3 + 2000
constraint 10*x[1] >= 7*x[3] + 2000;

% |X4 - 0.6*X2| <= 150  =>  |10*X4 - 6*X2| <= 1500
constraint abs(10*x[4] - 6*x[2]) <= 1500;

% |0.8*X3 - X1| <= 300  =>  |8*X3 - 10*X1| <= 3000
constraint abs(8*x[3] - 10*x[1]) <= 3000;

% X4 >= X2 + 50
constraint x[4] >= x[2] + 50;

% ---- Objective ----
var int: totalCost = sum(p in P)(cost[p] * x[p]);
solve minimize totalCost;

% ---- Output ----
output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "TotalCost=", show(totalCost), "\n",
  "RoundedTotalCost=", show(totalCost), "\n"  % already integral
];