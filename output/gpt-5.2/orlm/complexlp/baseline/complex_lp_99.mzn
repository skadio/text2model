int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap = array2d(V, V,
[
  0, 14,  9,  8,  7,  8,
  4,  0,  9, 10,  0, 12,
  4, 12,  0, 13, 20, 16,
 10,  8, 12,  0,  0, 18,
  3, 13, 11, 20,  0,  2,
 17,  4,  8,  2, 12,  0
]);

int: BIG = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..BIG: f;

% Capacity constraints (and force zero flow on non-existing arcs)
constraint forall(i in V, j in V)(
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Maximize total flow into sink (equivalently out of source by conservation)
var 0..BIG: maxflow = sum(i in V)(f[i,t]);

solve maximize maxflow;

output [
  "Maximum flow from ", show(s), " to ", show(t), " = ", show(maxflow), " GB/s\n"
];