int: N = 7;
set of int: W = 1..N;

array[W] of int: supply = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: demand = [499, 173, 293, 158, 15, 78, 278];

array[W, W] of int: cost = array2d(W, W, [
  0, 36, 36, 48, 10, 20, 48,
  28, 0, 16, 18, 36, 42, 12,
  6, 40, 0, 49, 31, 1, 46,
  14, 22, 4, 0, 9, 12, 1,
  50, 44, 7, 48, 0, 7, 25,
  26, 9, 33, 38, 8, 0, 30,
  8, 9, 2, 13, 8, 49, 0
]);

int: total_supply = sum(i in W)(supply[i]);
int: total_demand = sum(i in W)(demand[i]);

array[W, W] of var 0..total_supply: x;

var 0..(max([cost[i,j] | i in W, j in W]) * total_supply): total_cost;

constraint total_supply >= total_demand;

constraint forall(i in W)(x[i,i] = 0);

constraint forall(i in W)(
  sum(j in W)(x[i,j]) <= supply[i]
);

constraint forall(i in W)(
  supply[i] + sum(j in W)(x[j,i]) - sum(j in W)(x[i,j]) >= demand[i]
);

constraint total_cost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x =\n", show(x), "\n"
];