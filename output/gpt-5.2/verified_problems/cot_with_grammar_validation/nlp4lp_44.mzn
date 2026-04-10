int: N;
float: Capacity;
array[1..N] of float: Size;

int: M = N;
array[1..N, 1..M] of var 0..1: x;
array[1..M] of var 0..1: used;

constraint forall (j in 1..N) (
  sum (d in 1..M) (x[j,d]) = 1
);

constraint forall (d in 1..M) (
  sum (j in 1..N) (Size[j] * x[j,d]) <= Capacity
);

constraint forall (d in 1..M, j in 1..N) (
  x[j,d] <= used[d]
);

solve minimize sum (d in 1..M) (used[d]);