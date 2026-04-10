int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [268, 222, 357, 128, 465, 48];
array[R] of int: need   = [165, 246, 262, 286, 439, 83];

array[R, R] of int: cost = array2d(R, R,
[
  0, 49, 11, 23,  2, 39,
 33,  0, 26,  2,  2, 14,
 12, 31,  0, 36, 30, 34,
 18, 50, 12,  0, 19, 20,
  3, 13, 20, 29,  0,  1,
  2,  9, 50, 36, 39,  0
]);

int: total_supply = sum(r in R)(supply[r]);
int: total_need   = sum(r in R)(need[r]);
int: BIG = max(total_supply, total_need);

array[R, R] of var 0..BIG: x;

int: max_cost = max(i in R, j in R)(cost[i,j]);
var 0..(BIG * max_cost): total_cost;

constraint forall(i in R)(x[i,i] = 0);

constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R)(
  supply[j] - sum(k in R)(x[j,k]) + sum(i in R)(x[i,j]) >= need[j]
);

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  show(total_cost)
];