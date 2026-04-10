include "globals.mzn";

% ----- Data (embedded) -----
int: n = 5;
set of int: C = 1..n;

array[C] of int: supply = [221, 98, 337, 425, 250];
array[C] of int: demand = [128, 317, 394, 108, 101];

array[C, C] of int: cost =
  [| 0, 20, 39,  4, 45
   | 1,  0,  8, 23, 44
   | 5, 46,  0, 36, 15
   | 3,  5, 10,  0, 27
   |37, 15,  7, 45,  0 |];

% Total supply equals total demand (feasibility check)
constraint sum(C)(supply[i]) = sum(C)(demand[i]);

% ----- Decision variables -----
% x[i,j] = amount shipped from city i to city j
array[C, C] of var 0..sum(supply): x;

% ----- Constraints -----
% Do not ship to self
constraint forall(i in C)(x[i,i] = 0);

% Outflow from each city equals its initial supply
constraint forall(i in C)(
  sum(j in C)(x[i,j]) = supply[i]
);

% Inflow to each city equals its required demand
constraint forall(j in C)(
  sum(i in C)(x[i,j]) = demand[j]
);

% ----- Objective -----
var int: total_cost = sum(i in C, j in C)(cost[i,j] * x[i,j]);
solve minimize total_cost;

% ----- Output -----
output [
  "Minimum total transportation cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (from i to j):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in C ]) ++ "\n" | i in C ])
];