int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost = [|
  0, 52, 89, 11 |
  52, 0, 14, 13 |
  89, 14, 0, 87 |
  11, 13, 87, 0
|];

array[CITIES, CITIES] of var 0..1: x;
array[CITIES] of var 1..n: u;

int: max_cost = sum(i in CITIES, j in CITIES)(cost[i,j]);
var 0..max_cost: total_cost;

constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

constraint u[1] = 1;
constraint forall(i in CITIES where i != 1)(u[i] >= 2 /\ u[i] <= n);

constraint forall(i in CITIES, j in CITIES where i != j /\ i != 1 /\ j != 1)(
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "min_total_cost=", show(total_cost), "\n",
  "x=\n",
  show(x), "\n"
];