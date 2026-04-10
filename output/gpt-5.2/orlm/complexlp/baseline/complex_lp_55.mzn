int: N = 6;
set of int: C = 1..N;

array[C] of int: supply = [467, 121, 109, 131, 500, 10];
array[C] of int: demand = [261, 209, 135, 146, 488, 30];

% Cost per unit shipped from i to j (i != j). Diagonal costs unused (set to 0).
array[C, C] of int: cost = array2d(C, C,
[
  0, 43,  8, 15, 37,  9,
  9,  0, 50, 37, 50, 29,
  3, 37,  0,  7, 18, 27,
 15,  3,  3,  0,  2, 48,
 34, 18, 44,  2,  0, 27,
 36, 49, 29, 12, 33,  0
]);

% Total supply equals total demand (feasibility check)
constraint sum(i in C)(supply[i]) = sum(i in C)(demand[i]);

% x[i,j] = units shipped from clinic i to clinic j
array[C, C] of var 0..max(supply): x;

% No need to ship from a clinic to itself
constraint forall(i in C)(x[i,i] = 0);

% Flow conservation: supply + inflow - outflow = demand
constraint forall(i in C)(
  supply[i] + sum(j in C)(x[j,i]) - sum(j in C)(x[i,j]) = demand[i]
);

% Objective: minimize transportation cost
var int: total_cost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipment matrix (rows=from, cols=to):\n"
] ++
[
  if j = 1 then "" else " " endif ++ show(x[i,j]) ++ if j = N then "\n" else "" endif
  | i in C, j in C
];