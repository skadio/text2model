% Emergency food redistribution (transportation problem)
int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [268, 222, 357, 128, 465, 48];
array[R] of int: demand = [165, 246, 262, 286, 439, 83];

array[R, R] of int: cost =
[|  0, 49, 11, 23,  2, 39
 | 33,  0, 26,  2,  2, 14
 | 12, 31,  0, 36, 30, 34
 | 18, 50, 12,  0, 19, 20
 |  3, 13, 20, 29,  0,  1
 |  2,  9, 50, 36, 39,  0 |];

int: total_supply = sum(i in R)(supply[i]);
int: total_demand = sum(i in R)(demand[i]);

% Add a dummy supplier to balance if total_supply < total_demand.
% Dummy supply creates food at 0 cost to meet remaining demand.
int: extra_supply = if total_supply < total_demand then total_demand - total_supply else 0 endif;
int: N2 = N + 1;
set of int: S = 1..N2;     % suppliers (including dummy)
set of int: D = 1..N;      % demand nodes (real regions)

array[S] of int: supply2 = [supply[i] | i in R] ++ [extra_supply];

array[S, D] of int: cost2 =
array2d(S, D,
  [ if i <= N then cost[i,j] else 0 endif
    | i in S, j in D ]
);

% Decision variables: shipped amount from supplier i to region j
array[S, D] of var 0..total_demand: x;

% Exact supply usage (including dummy if needed)
constraint forall(i in S)(
  sum(j in D)(x[i,j]) = supply2[i]
);

% Exact demand satisfaction
constraint forall(j in D)(
  sum(i in S)(x[i,j]) = demand[j]
);

var int: total_cost = sum(i in S, j in D)(cost2[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "minimum_cost=", show(total_cost), "\n"
];