% Transportation / redistribution of food supplies among 4 districts
% Minimize total transportation cost while meeting exact needs.

int: N = 4;
set of int: D = 1..N;

array[D] of int: supply = [412, 92, 265, 342];
array[D] of int: demand = [74, 334, 61, 352];

% cost[i,j] = cost to ship 1 unit from i to j
% (No self-shipment; set to 0 and constrain x[i,i]=0)
array[D, D] of int: cost =
[|  0, 20, 43,  1
 | 42,  0, 32, 13
 | 27,  5,  0, 10
 | 30, 22,  9,  0 |];

% Shipment quantities
array[D, D] of var 0..max(supply): x;

% No shipping to self
constraint forall(i in D)(x[i,i] = 0);

% Flow conservation: initial supply + inflow - outflow = demand
constraint forall(i in D)(
  supply[i] + sum(j in D)(x[j,i]) - sum(j in D)(x[i,j]) = demand[i]
);

var int: total_cost = sum(i in D, j in D)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (units shipped from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in D]) ++ "\n" | i in D ])
];