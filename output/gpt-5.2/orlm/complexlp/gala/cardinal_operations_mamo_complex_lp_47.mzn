include "globals.mzn";

% Transportation / redistribution min-cost flow between 6 regions
int: n = 6;
set of int: R = 1..n;

array[R] of int: stock = [319, 281, 247, 237, 29, 453];
array[R] of int: need  = [243, 243, 124, 202, 84, 28];

% Cost to ship 1 unit from i to j (0 on diagonal; allowed but pointless)
array[R, R] of int: cost =
[| 0, 11, 30, 12, 48, 23
 | 1,  0, 27,  9, 26, 13
 | 29, 6,  0, 27, 13, 44
 | 6, 50, 12,  0, 19, 32
 | 26,13, 29,  2,  0, 24
 | 9, 26,  2, 37, 22,  0 |];

% Sanity: total stock must equal total need for exact balancing
constraint sum(i in R)(stock[i]) = sum(i in R)(need[i]);

% Decision variables: shipped units from i to j
int: totalStock = sum(i in R)(stock[i]);
array[R, R] of var 0..totalStock: x;

% No self-shipping (optional)
constraint forall(i in R)(x[i,i] = 0);

% Flow balance at each region:
% stock + inflow - outflow = need
constraint forall(i in R)(
  stock[i] + sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = need[i]
);

% Objective: minimize total transportation cost
var int: totalCost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Minimum cost = ", show(totalCost), "\n",
  "Shipments x[i,j] (units):\n",
  concat([ concat([ if j=1 then "" else " " endif ++
                    show(x[i,j])
                  | j in R ]) ++ "\n"
         | i in R ])
];