% China Railroad freight car relocation - minimum cost flow (linear optimization)
include "globals.mzn";

int: N = 5;
set of int: LOC = 1..N;

% Supply (positive) / demand (negative) at each location: current - needed
array[LOC] of int: b = [
  120 - 150,  % loc 1
  330 - 200,  % loc 2
  400 - 600,  % loc 3
  400 - 200,  % loc 4
  600 - 400   % loc 5
];

% Cost matrix (0 on diagonal; only given for i<j, mirrored to make full matrix)
array[LOC, LOC] of int: cost = array2d(LOC, LOC, [
  0,  0, 11, 13, 28,
  0,  0, 18,  8, 46,
  11, 18, 0,  9, 27,
  13,  8,  9, 0, 20,
  28, 46, 27, 20, 0
]);

% Decision variables: number of cars moved from i to j (i != j)
% Upper bound can be total cars in system (safe bound)
int: TOTAL = 120 + 330 + 400 + 400 + 600;
array[LOC, LOC] of var 0..TOTAL: x;

% No self-moves
constraint forall(i in LOC)( x[i,i] = 0 );

% Flow balance: outgoing - incoming = b[i]
constraint forall(i in LOC)(
  sum(j in LOC where j != i)(x[i,j]) - sum(j in LOC where j != i)(x[j,i]) = b[i]
);

% Objective: minimize total transportation cost
var int: total_cost =
  sum(i in LOC, j in LOC where i != j)( cost[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum total cost (rounded to nearest dollar): ", show(total_cost), "\n",
  "Shipments x[i,j] (cars moved from i to j):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(x[i,j]) | j in LOC ]) ++ "\n" | i in LOC ])
];