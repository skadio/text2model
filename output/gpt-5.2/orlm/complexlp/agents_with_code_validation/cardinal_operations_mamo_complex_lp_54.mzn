% Transportation problem: minimize redistribution cost to meet exact demands

int: nDistricts = 4;
set of int: D = 1..nDistricts;

array[D] of int: supply = [412, 92, 265, 342];
array[D] of int: demand = [74, 334, 61, 352];

array[D, D] of int: cost =
  [|  0, 20, 43,  1
   | 42,  0, 32, 13
   | 27,  5,  0, 10
   | 30, 22,  9,  0 |];

% Total supply equals total demand, so we can enforce exact flow balance.
constraint sum(i in D)(supply[i]) = sum(j in D)(demand[j]);

% Decision variables: ship[i,j] = units shipped from i to j
array[D, D] of var 0..max(supply): ship;

% No self-shipment
constraint forall(i in D)(ship[i,i] = 0);

% Flow conservation: after shipping, each district ends with exactly its demand
% supply[j] + inflow(j) - outflow(j) = demand[j]
constraint forall(j in D)(
  supply[j] + sum(i in D)(ship[i,j]) - sum(k in D)(ship[j,k]) = demand[j]
);

var int: total_cost = sum(i in D, j in D)(cost[i,j] * ship[i,j]);

solve :: int_search([ship[i,j] | i in D, j in D], first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "ship =\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(ship[i,j]) | j in D]) ++ "\n" | i in D ])
];