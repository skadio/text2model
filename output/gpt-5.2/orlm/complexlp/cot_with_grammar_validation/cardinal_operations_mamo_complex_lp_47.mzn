int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [319, 281, 247, 237, 29, 453];
array[R] of int: demand = [243, 243, 124, 202, 84, 28];

array[R, R] of int: cost = array2d(R, R, [
  0, 11, 30, 12, 48, 23,
  1, 0, 27, 9, 26, 13,
  29, 6, 0, 27, 13, 44,
  6, 50, 12, 0, 19, 32,
  26, 13, 29, 2, 0, 24,
  9, 26, 2, 37, 22, 0
]);

array[R, R] of var 0..453: x;

var int: total_cost;

constraint forall(i in R) (x[i,i] = 0);

constraint forall(i in R) (
  sum(j in R)(x[i,j]) <= supply[i]
);

constraint forall(j in R) (
  sum(i in R)(x[i,j]) + supply[j] - sum(k in R)(x[j,k]) = demand[j]
);

constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "x=\n",
  show(x), "\n"
];