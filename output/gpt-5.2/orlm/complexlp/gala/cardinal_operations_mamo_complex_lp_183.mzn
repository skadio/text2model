% Freight car relocation (min-cost flow / transportation problem)
% Data embedded as required.

include "globals.mzn";

int: n = 5;
set of int: R = 1..n;

array[R] of int: current = [120, 330, 400, 400, 600];
array[R] of int: needed  = [150, 200, 600, 200, 400];

array[R] of int: surplus = [ current[i] - needed[i] | i in R ]; % >0 supply, <0 demand

% Costs (symmetric), cost[i,i]=0
array[R, R] of int: cost =
[|  0,  0, 13, 11, 28
 |  0,  0, 18,  8, 46
 | 13, 18,  0,  9, 27
 | 11,  8,  9,  0, 20
 | 28, 46, 27, 20,  0 |];

% Total supply equals total demand (should hold)
constraint sum(i in R)(surplus[i]) = 0;

% Decision: x[i,j] cars moved from i to j (i != j). We allow i=j but force it to 0.
int: BIG = sum(i in R where surplus[i] > 0)(surplus[i]);

array[R, R] of var 0..BIG: x;

constraint forall(i in R)(x[i,i] = 0);

% Flow balance:
% outgoing - incoming = surplus (positive means net export; negative means net import)
constraint forall(i in R)(
  sum(j in R)(x[i,j]) - sum(j in R)(x[j,i]) = surplus[i]
);

% Objective: minimize total cost
var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Total cost (units) = ", show(total_cost), "\n",
  "Move matrix x[i,j] (cars moved from i to j):\n",
  concat([ concat([ if j = n then show(x[i,j]) ++ "\n" else show(x[i,j]) ++ " " endif | j in R ]) | i in R ])
];