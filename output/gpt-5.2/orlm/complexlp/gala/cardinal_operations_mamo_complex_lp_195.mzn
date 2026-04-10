% China Railroad freight car relocations (5 regions)
% Min-cost flow / transportation model with embedded data.

include "globals.mzn";

int: n = 5;
set of int: R = 1..n;

% Costs (units per car) to move from i to j
array[R, R] of int: cost =
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

% Current cars available and required cars (needs)
array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: need   = [300, 400, 800, 200, 300];

% Decision: cars shipped from region i to region j
array[R, R] of var 0..sum(supply): x;

% No self-shipments
constraint forall(i in R)( x[i,i] = 0 );

% Flow balance: final cars in each region must meet need
% final_j = supply_j + inflow_j - outflow_j
constraint forall(j in R)(
  supply[j] + sum(i in R)(x[i,j]) - sum(k in R)(x[j,k]) = need[j]
);

% Objective: minimize total transport cost
var int: total_cost = sum(i in R, j in R)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), " (rounded)\n",
  "Shipments x[i,j] (cars moved from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in R ]) ++ "\n" | i in R ])
];