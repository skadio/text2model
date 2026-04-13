include "globals.mzn";

% ----- Data (embedded) -----
int: n = 4;
set of int: C = 1..n;

array[C] of int: initial = [330, 294, 474, 86];
array[C] of int: need    = [476,  92, 385, 203];

% cost[i,j] = unit transport cost from clinic i to clinic j (i != j), 0 on diagonal
array[C, C] of int: cost =
  array2d(C, C,
  [  0,  2, 12, 19,
    28,  0,  9, 10,
    23, 46,  0,  7,
    19, 16, 23,  0
  ]);

% ----- Feasibility check: total supply must cover total demand -----
constraint sum(i in C)(initial[i]) >= sum(i in C)(need[i]);

% ----- Decision variables -----
% x[i,j] = units shipped from clinic i to clinic j (i != j)
int: totalSupply = sum(i in C)(initial[i]);
array[C, C] of var 0..totalSupply: x;

% no self shipment
constraint forall(i in C)(x[i,i] = 0);

% supply capacity at each origin
constraint forall(i in C)(
  sum(j in C where j != i)(x[i,j]) <= initial[i]
);

% meet (or exceed) requirement at each destination
constraint forall(j in C)(
  initial[j] + sum(i in C where i != j)(x[i,j]) - sum(k in C where k != j)(x[j,k]) >= need[j]
);

% ----- Objective -----
var int: totalCost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

solve minimize totalCost;

% ----- Output -----
output [
  "Minimum cost = ", show(totalCost), "\n",
  "Shipment matrix x (rows=from, cols=to):\n",
  concat([ concat([ if j = 1 then "" else " " endif ++ show(x[i,j]) | j in C ]) ++ "\n" | i in C ])
];