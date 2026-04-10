% International warehouse reallocation (min-cost flow)

int: N = 6;
set of int: W = 1..N;

array[W] of int: supply = [497, 39, 416, 71, 445, 471];
array[W] of int: demand = [161, 257, 252, 251, 372, 370];

array[W, W] of int: cost =
[| 0,  5,  7,  5, 27, 49
 |31,  0, 14, 31,  3,  4
 | 9, 13,  0, 23, 38, 19
 |47, 34,  7,  0, 34, 35
 |21, 11,  6,  7,  0, 50
 |28, 41, 34, 17, 32,  0 |];

array[W] of int: surplus = [supply[i] - demand[i] | i in W];
set of int: S = { i | i in W where surplus[i] > 0 };
set of int: D = { j | j in W where surplus[j] < 0 };

int: total_surplus = sum(i in S)(surplus[i]);            % should equal total deficit
int: max_cost = max([cost[i,j] | i in W, j in W]);

% Ship only from surplus nodes to deficit nodes (much smaller model, faster)
array[S, D] of var 0..total_surplus: ship;

var 0..(total_surplus * max_cost): total_cost;

constraint total_surplus = -sum(j in D)(surplus[j]);

% Each surplus warehouse ships out exactly its surplus
constraint forall(i in S)(
  sum(j in D)(ship[i,j]) = surplus[i]
);

% Each deficit warehouse receives exactly its deficit
constraint forall(j in D)(
  sum(i in S)(ship[i,j]) = -surplus[j]
);

constraint total_cost = sum(i in S, j in D)(cost[i,j] * ship[i,j]);

solve minimize total_cost;