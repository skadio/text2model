int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
  0, 40, 40, 56, 93,
  40, 0, 52, 71, 90,
  40, 52, 0, 57, 14,
  56, 71, 57, 0, 13,
  93, 90, 14, 13, 0
]);

array[CITIES, CITIES] of var 0..1: x;
array[CITIES] of var 0..n-1: u;

constraint forall(i in CITIES) (x[i,i] = 0);

constraint forall(i in CITIES) (
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES) (
  sum(i in CITIES)(x[i,j]) = 1
);

constraint u[1] = 0;
constraint forall(i in 2..n) (u[i] >= 1 /\ u[i] <= n - 1);

constraint forall(i in 2..n, j in 2..n where i != j) (
  u[i] - u[j] + n * x[i,j] <= n - 1
);

solve minimize sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);