int: N = 6;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
[|
  0, 43, 39, 97, 84, 67 |
  43, 0, 18, 92, 27, 51 |
  39, 18, 0, 84, 60, 15 |
  97, 92, 84, 0, 42, 32 |
  84, 27, 60, 42, 0, 18 |
  67, 51, 15, 32, 18, 0
|];

array[CITIES, CITIES] of var 0..1: x;
array[CITIES] of var 1..N: u;
var 0..1000000: total_cost;

constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

constraint u[1] = 1;
constraint forall(i in 2..N) (u[i] >= 2 /\ u[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j) (
  u[i] - u[j] + N * x[i,j] <= N - 1
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "x=\n", show(x), "\n"
];