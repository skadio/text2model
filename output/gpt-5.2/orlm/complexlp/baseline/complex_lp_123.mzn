int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
 % to:  0  1  2  3  4  5  6  7  8
        0, 6,16,12,16, 3, 9, 3,13, % from 0
        2, 0, 0,20,13, 7,20,11,13, % from 1
        4,15, 0,14,13, 5,12,14,16, % from 2
        1, 0, 2, 0, 8, 7,11,14,16, % from 3
        4,19, 7,14, 0, 1,20,14,16, % from 4
        0, 0,14, 4,17, 0, 2,20, 9, % from 5
       12,19, 3, 3, 0, 0, 0,13, 3, % from 6
        8,19,16, 4, 6,13, 9, 0,15, % from 7
       11, 6, 0, 6,10, 9, 3, 1, 0  % from 8
]);

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

var 0..U: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "maxflow = ", show(maxflow), "\n"
];