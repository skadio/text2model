% Freight car relocation / transportation problem (min-cost flow)
% Data embedded directly.

int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: present = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

% Net supply at each location: positive = surplus (can ship out), negative = deficit (needs inflow)
array[LOC] of int: supply = [present[i] - needed[i] | i in LOC];

% Costs for moving one car between locations (undirected; can move either way).
% Build a symmetric cost matrix; 0 on diagonal.
array[LOC, LOC] of int: cost =
  array2d(LOC, LOC,
  [
    0,  0, 13, 11, 28,
    0,  0, 18,  8, 46,
   13, 18,  0,  9, 27,
   11,  8,  9,  0, 20,
   28, 46, 27, 20,  0
  ]);

% Decision variables: number of cars moved from i to j (i != j)
array[LOC, LOC] of var 0..1000000: x;

% No self-shipments
constraint forall(i in LOC)(x[i,i] = 0);

% Flow balance: outflow - inflow = supply (surplus ships out, deficit receives)
constraint forall(i in LOC)(
  sum(j in LOC)(x[i,j]) - sum(j in LOC)(x[j,i]) = supply[i]
);

% Objective: minimize total cost
var int: total_cost = sum(i in LOC, j in LOC)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipments (i -> j : cars) for i != j:\n"
] ++
[
  if i != j /\ fix(x[i,j]) > 0 then
    "  " ++ show(i) ++ " -> " ++ show(j) ++ " : " ++ show(x[i,j]) ++ " (cost " ++ show(cost[i,j]) ++ ")\n"
  else
    ""
  endif
  | i in LOC, j in LOC
];