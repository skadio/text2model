% Medical supplies redistribution among hospitals (min-cost flow)

int: n = 7;
set of int: H = 1..n;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: need  = [ 19, 138, 110, 446, 341, 428,  47];

% Cost matrix (include 0 on diagonal)
array[H, H] of int: cost =
[| 0, 12, 47, 39,  4, 21, 31
 | 14, 0, 39, 12, 31, 29, 15
 | 15, 6,  0, 26, 12,  5,  3
 | 39,47, 42,  0, 33, 48,  2
 | 35,25, 46, 12,  0, 25, 45
 | 39,28, 28, 11, 16,  0, 13
 | 42,43, 49, 41, 41, 18,  0 |];

array[H] of int: surplus = [stock[i] - need[i] | i in H];

int: total_surplus = sum(i in H)(max(surplus[i], 0));
int: total_deficit = sum(i in H)(max(-surplus[i], 0));

% If total_surplus < total_deficit, the instance is infeasible
constraint total_surplus >= total_deficit;

% x[i,j] = units shipped from i to j
array[H, H] of var 0..total_surplus: x;

% No self-shipping
constraint forall(i in H)(x[i,i] = 0);

% Flow conservation per hospital:
% final = stock - outgoing + incoming
% require final >= need  <=>  incoming - outgoing >= need - stock = -surplus
constraint forall(k in H)(
    sum(i in H)(x[i,k]) - sum(j in H)(x[k,j]) >= -surplus[k]
);

% Also, a hospital cannot ship more than its surplus (otherwise it would go below its own need)
constraint forall(i in H)(
    sum(j in H)(x[i,j]) <= max(surplus[i], 0)
);

var int: total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "minimum_cost=", show(total_cost), "\n",
  "shipments (i->j:qty):\n",
  concat([
    if fix(x[i,j]) > 0 then
      show(i) ++ "->" ++ show(j) ++ ":" ++ show(x[i,j]) ++ " (c=" ++ show(cost[i,j]) ++ ")\n"
    else "" endif
    | i in H, j in H
  ])
];