include "globals.mzn";

% Transportation problem: move supplies between 7 hospitals to meet required levels
int: n = 7;
set of int: H = 1..n;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: req   = [ 19, 138, 110, 446, 341, 428,  47];

% cost[i,j] = unit transportation cost from i to j (0 on diagonal)
array[H, H] of int: cost =
  [| 0, 12, 47, 39,  4, 21, 31
   |14,  0, 39, 12, 31, 29, 15
   |15,  6,  0, 26, 12,  5,  3
   |39, 47, 42,  0, 33, 48,  2
   |35, 25, 46, 12,  0, 25, 45
   |39, 28, 28, 11, 16,  0, 13
   |42, 43, 49, 41, 41, 18,  0 |];

% Demand = additional units needed at each hospital (cannot be negative)
array[H] of int: need = [max(0, req[i] - stock[i]) | i in H];
% Supply = surplus units available to ship from each hospital (cannot be negative)
array[H] of int: supply = [max(0, stock[i] - req[i]) | i in H];

int: totalNeed = sum(i in H)(need[i]);
int: totalSupply = sum(i in H)(supply[i]);

constraint totalSupply >= totalNeed; % feasibility check

% x[i,j] = units shipped from i to j
array[H, H] of var 0..totalNeed: x;

% No self-shipping
constraint forall(i in H)(x[i,i] = 0);

% Outgoing shipments limited by surplus supply
constraint forall(i in H)(
  sum(j in H)(x[i,j]) <= supply[i]
);

% Incoming shipments must cover each hospital's need
constraint forall(j in H)(
  sum(i in H)(x[i,j]) >= need[j]
);

% Objective: minimize total transportation cost
var int: totalCost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Minimum cost = ", show(totalCost), "\n",
  "Shipments x[i,j] (rows=from, cols=to):\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in H ]) ++ "\n" | i in H ])
];