int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [42, 32, 398, 224, 210, 209];
array[R] of int: demand = [74, 476, 2, 235, 221, 72];

array[R, R] of int: cost = [|
  0, 16, 48, 42, 50,  8 |
 27,  0, 23, 37, 39, 29 |
 49, 39,  0, 33, 50,  6 |
 23, 49, 46,  0, 50,  6 |
 45, 47, 48, 26,  0, 39 |
 33, 11,  9,  4, 12,  0 |
|];

int: total_supply = sum(r in R)(supply[r]);

array[R, R] of var 0..total_supply: x;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  supply[i] + sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = demand[i]
);

solve minimize sum(i in R, j in R)(cost[i,j] * x[i,j]);

output [
  "min_cost=", show(sum(i in R, j in R)(cost[i,j] * x[i,j])), "\n",
  "x=\n", show(x), "\n"
];