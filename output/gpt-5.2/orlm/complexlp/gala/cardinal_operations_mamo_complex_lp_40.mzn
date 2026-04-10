include "globals.mzn";

% Warehouses
int: n = 6;
set of int: W = 1..n;

% Stock (supply) and required (demand)
array[W] of int: have = [497, 39, 416, 71, 445, 471];
array[W] of int: need = [161, 257, 252, 251, 372, 370];

% Unit transportation costs c[i,j] (cost to move 1 unit from i to j)
array[W, W] of int: c =
[|  0,  5,  7,  5, 27, 49
 | 31,  0, 14, 31,  3,  4
 |  9, 13,  0, 23, 38, 19
 | 47, 34,  7,  0, 34, 35
 | 21, 11,  6,  7,  0, 50
 | 28, 41, 34, 17, 32,  0 |];

% Decision variables: flow[i,j] = units shipped from i to j
array[W, W] of var 0..max(have): flow;

% No self-shipment (can be 0 only)
constraint forall(i in W)(flow[i,i] = 0);

% Flow conservation to meet demands exactly:
% initial have + inflow - outflow = need  for each warehouse
constraint
  forall(k in W) (
    have[k] + sum(i in W)(flow[i,k]) - sum(j in W)(flow[k,j]) = need[k]
  );

% Objective: minimize total transportation cost
var int: total_cost = sum(i in W, j in W)(c[i,j] * flow[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Flow matrix (from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(flow[i,j]) | j in W ]) ++ "\n" | i in W ])
];