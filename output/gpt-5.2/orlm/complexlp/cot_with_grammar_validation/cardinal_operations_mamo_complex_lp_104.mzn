int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
  array2d(V, V,
    [  0,  6,  1, 14, 20,  6, 13, 13, 15,
       2,  0,  5,  5, 13,  5, 12,  9, 15,
      15,  0,  0,  8, 16,  9, 19, 15,  6,
      13,  8,  0,  0, 14, 12,  9,  1,  2,
       4, 14, 19, 16,  0, 14, 11, 11,  2,
      19, 18,  5, 20,  9,  0, 11,  5,  7,
      11, 14, 20, 17, 11, 13,  0, 11, 16,
       6,  2, 17,  0, 10, 13, 17,  0,  9,
       8,  9,  7, 18, 12, 13,  5,  9,  0
    ]
  );

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;
var 0..U: maxflow;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];