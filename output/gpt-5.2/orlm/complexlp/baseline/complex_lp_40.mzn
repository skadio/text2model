int: N = 6;
set of int: W = 1..N;

array[W] of int: supply = [497, 39, 416, 71, 445, 471];
array[W] of int: demand = [161, 257, 252, 251, 372, 370];

% Cost per unit shipped from i to j (i != j). Diagonal set to 0.
array[W,W] of int: cost =
[|  0,  5,  7,  5, 27, 49
 | 31,  0, 14, 31,  3,  4
 |  9, 13,  0, 23, 38, 19
 | 47, 34,  7,  0, 34, 35
 | 21, 11,  6,  7,  0, 50
 | 28, 41, 34, 17, 32,  0 |];

int: total_supply = sum(i in W)(supply[i]);
int: total_demand = sum(i in W)(demand[i]);
constraint total_supply = total_demand; % balanced transportation

array[W,W] of var 0..total_supply: x; % shipped units from i to j

% No self-shipping
constraint forall(i in W)(x[i,i] = 0);

% Supply constraints: total outgoing from i equals its supply
constraint forall(i in W)(
  sum(j in W)(x[i,j]) = supply[i]
);

% Demand constraints: total incoming to j equals its demand
constraint forall(j in W)(
  sum(i in W)(x[i,j]) = demand[j]
);

var int: total_cost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (i->j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in W ]) ++ "\n" | i in W ])
];