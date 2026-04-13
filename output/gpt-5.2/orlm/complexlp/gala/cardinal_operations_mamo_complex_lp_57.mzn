include "globals.mzn";

% Food relocation / transportation problem (min-cost flow)

int: n = 6;
set of int: C = 1..n;

array[C] of int: supply = [255, 250, 314, 8, 385, 440];
array[C] of int: demand = [251, 200, 366, 114, 59, 287];

% Cost matrix: cost[i,j] = cost to ship 1 ton from city i to city j
% Diagonal is 0 (no shipment needed).
array[C, C] of int: cost =
 [|  0, 26, 39, 13, 37, 28
  | 36,  0, 48,  5, 22, 14
  | 38, 36,  0, 12, 45, 36
  | 32, 18, 47,  0,  7,  9
  | 18,  6, 12, 20,  0, 42
  |  4, 28, 42, 43,  7,  0 |];

% Decision variables: x[i,j] = tons shipped from i to j
array[C, C] of var 0..sum(supply): x;

% Satisfy demand and respect supplies
constraint forall(i in C)(
  sum(j in C)(x[i,j]) <= supply[i]        % cannot ship more than available
);

constraint forall(j in C)(
  sum(i in C)(x[i,j]) >= demand[j]        % each city receives at least its requirement
);

% Objective: minimize total transportation cost
var int: total_cost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (tons):\n",
  concat([ concat([ if j = 1 then "" else " " endif ++ show(x[i,j]) | j in C]) ++ "\n" | i in C ])
];