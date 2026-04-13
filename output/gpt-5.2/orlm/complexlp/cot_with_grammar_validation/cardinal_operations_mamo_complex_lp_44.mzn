int: N = 7;
set of int: R = 1..N;

array[R] of int: supply = [318, 349, 129, 381, 430, 52, 124];
array[R] of int: demand = [309, 9, 279, 71, 365, 233, 483];

array[R, R] of int: cost =
  [| 0,  2, 26, 19, 16, 26, 36
   |27,  0, 26,  4, 15, 43, 25
   |17, 45,  0, 18, 36, 37, 39
   |19, 16, 14,  0,  5, 35,  9
   |44, 47,  4,  3,  0,  2,  4
   |30, 12, 28, 10, 16,  0, 25
   |19, 16, 10,  2, 50,  4,  0
  |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);
int: max_cost = max([cost[i,j] | i in R, j in R]);

array[R, R] of var 0..total_supply: x;

var 0..(total_supply * max_cost): total_cost;

constraint total_supply >= total_demand;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  supply[j] + sum(i in R)(x[i,j]) - sum(k in R)(x[j,k]) >= demand[j]
);

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output ["total_cost = \(total_cost)\n"];