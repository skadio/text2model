% Maximum flow in a directed network (8 nodes)

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = array2d(V, V, [
  0, 11,  1,  6,  4,  5,  7,  1,
  3,  0, 15, 15, 16,  9, 14, 12,
 19,  9,  0,  5,  9, 11, 16,  3,
 15,  1, 14,  0,  0,  4,  1, 15,
  8, 16,  7,  3,  0, 16, 10, 11,
  7,  8,  1, 11, 19,  0,  3,  3,
  2, 19,  2,  6, 12, 20,  0,  6,
 15, 17,  4,  7,  8,  2, 16,  0
]);

int: total_cap_out_s = sum(j in V)(cap[s,j]);
int: total_cap_in_t  = sum(i in V)(cap[i,t]);
int: UB = min(total_cap_out_s, total_cap_in_t);

array[V, V] of var 0..UB: f;
var 0..UB: maxflow;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define maxflow (net outflow from source) and ensure it matches net inflow to sink
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];