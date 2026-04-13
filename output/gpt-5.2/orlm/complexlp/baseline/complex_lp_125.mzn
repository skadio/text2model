int: N = 9;
set of int: V = 0..N-1;
int: S = 0;
int: T = 8;

array[V,V] of int: cap =
[
|  0,  5,  2,  7, 17,  4,  1,  2, 13 |
| 12,  0, 15, 18,  8,  9,  8,  1, 15 |
| 17, 16,  0, 20, 17, 13,  2, 19,  6 |
|  5,  9, 14,  0, 10, 18, 20,  9, 18 |
| 12, 14,  7,  6,  0,  6, 17,  4,  9 |
| 12, 11, 10,  1, 13,  0, 14, 12, 14 |
| 13,  7,  3,  9,  1, 14,  0,  7, 16 |
| 18, 15,  8,  0, 12, 13,  5,  0, 17 |
|  3, 11, 15, 14,  0,  4, 18, 16,  0 |
];

array[V,V] of var 0..max(cap): f;

constraint
  forall(i,j in V) (
    f[i,j] <= cap[i,j]
  );

var 0..sum(j in V)(cap[S,j]): F;

constraint
  F = sum(j in V)(f[S,j]) - sum(i in V)(f[i,S]);

constraint
  forall(k in V where k != S /\ k != T) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

solve maximize F;

output [
  "Maximum flow (thousands of gallons per hour) = ", show(F), "\n"
];