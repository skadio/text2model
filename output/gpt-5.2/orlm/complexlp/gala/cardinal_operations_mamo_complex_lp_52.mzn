include "globals.mzn";

% Medical supplies transportation / transshipment problem
int: n = 5;
set of int: R = 1..n;

% Stock (supply) and required (demand)
array[R] of int: stock = [410, 266, 132, 6, 485];
array[R] of int: need  = [274, 331, 232, 359, 74];

% Transportation costs: cost[i,j] is cost per unit shipped from i to j
% Diagonal entries are 0 (no cost to keep supplies in the same region).
array[R, R] of int: cost =
  [| 0, 24,  3, 27, 31
   |24,  0, 11,  7, 37
   |30,  1,  0, 38, 22
   |36, 18, 17,  0, 35
   |41, 35, 33, 33,  0
  |];

% Decision variables: x[i,j] = units shipped from region i to region j
int: total_stock = sum(r in R)(stock[r]);
array[R, R] of var 0..total_stock: x;

% Supply constraints: cannot ship more than available stock from each region
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= stock[i]
);

% Demand constraints: each region must receive at least its required need
constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= need[j]
);

% Objective: minimize total transportation cost
var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (from i to j):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(x[i,j])
                    | j in R ]) ++ "\n"
           | i in R ])
];