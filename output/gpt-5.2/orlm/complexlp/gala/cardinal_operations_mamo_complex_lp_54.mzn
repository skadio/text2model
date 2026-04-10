include "globals.mzn";

% Food redistribution / minimum-cost transportation problem

int: n = 4;
set of int: D = 1..n;

array[D] of int: supply = [412, 92, 265, 342];
array[D] of int: demand = [74, 334, 61, 352];

% Cost to ship 1 unit from i to j. (Diagonal is 0; shipping to self allowed but useless.)
array[D, D] of int: cost =
  [| 0, 20, 43,  1
   | 42, 0, 32, 13
   | 27, 5,  0, 10
   | 30, 22, 9,  0 |];

% Decision variables: x[i,j] = units shipped from district i to district j
int: total_supply = sum(i in D)(supply[i]);
array[D, D] of var 0..total_supply: x;

% Supply constraints: ship out exactly the supply available
constraint forall(i in D) (
  sum(j in D)(x[i,j]) = supply[i]
);

% Demand constraints: receive exactly the demand required
constraint forall(j in D) (
  sum(i in D)(x[i,j]) = demand[j]
);

% Objective: minimize total transportation cost
var int: total_cost = sum(i in D, j in D)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (rows=from i, cols=to j):\n",
  concat([ concat([ show(x[i,j]) ++ if j < n then "\t" else "\n" endif
                  | j in D ])
         | i in D ])
];