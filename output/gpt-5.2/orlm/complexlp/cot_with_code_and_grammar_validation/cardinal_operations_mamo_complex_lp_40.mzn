% International warehouse reallocation (min-cost flow)

int: N = 6;
set of int: W = 1..N;

array[W] of int: have = [497, 39, 416, 71, 445, 471];
array[W] of int: need = [161, 257, 252, 251, 372, 370];

% cost[i,j] = cost to ship 1 unit from i to j
array[W,W] of int: cost =
 [|  0,  5,  7,  5, 27, 49
  | 31,  0, 14, 31,  3,  4
  |  9, 13,  0, 23, 38, 19
  | 47, 34,  7,  0, 34, 35
  | 21, 11,  6,  7,  0, 50
  | 28, 41, 34, 17, 32,  0 |];

array[W] of int: surplus = [max(0, have[i] - need[i]) | i in W];
array[W] of int: deficit = [max(0, need[i] - have[i]) | i in W];

int: total_surplus = sum(i in W)(surplus[i]);
int: total_deficit = sum(i in W)(deficit[i]);

% Feasibility: enough total product to meet total need
constraint total_surplus >= total_deficit;

% Decision variables: ship only from surplus nodes to deficit nodes
array[W,W] of var 0..total_deficit: x;

% Disallow self shipments and shipments that can't happen (from non-surplus / to non-deficit)
constraint forall(i in W)(x[i,i] = 0);
constraint forall(i in W, j in W where surplus[i] = 0)(x[i,j] = 0);
constraint forall(i in W, j in W where deficit[j] = 0)(x[i,j] = 0);

% Ship out of i at most its surplus
constraint forall(i in W)(
  sum(j in W)(x[i,j]) <= surplus[i]
);

% Each deficit node j must receive exactly its deficit
constraint forall(j in W)(
  sum(i in W)(x[i,j]) = deficit[j]
);

var int: total_cost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x =\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in W]) ++ "\n" | i in W ])
];