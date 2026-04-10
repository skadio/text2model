int: n = 5;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost = [|
  0, 50, 48, 99, 91,
  50, 0, 57, 84, 72,
  48, 57, 0, 46, 86,
  99, 84, 46, 0, 29,
  91, 72, 86, 29, 0
|];

array[Cities, Cities] of var 0..1: x;
array[Cities] of var 1..n: u;
var 0..1000000: total_cost;

constraint forall(i in Cities) (x[i,i] = 0);

constraint forall(i in Cities) (
  sum(j in Cities)(x[i,j]) = 1
);

constraint forall(j in Cities) (
  sum(i in Cities)(x[i,j]) = 1
);

constraint u[1] = 1;
constraint forall(i in 2..n) (u[i] >= 2 /\ u[i] <= n);

constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + n * x[i,j] <= n - 1
);

constraint total_cost = sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n"
];