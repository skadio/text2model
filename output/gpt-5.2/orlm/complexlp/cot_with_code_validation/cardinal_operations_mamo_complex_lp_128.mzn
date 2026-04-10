% Max flow from source s to sink t with embedded data

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap = array2d(V, V, [
  0, 16,  6, 16,  2, 17, 15,
  7,  0, 13,  3,  0,  8, 17,
  3, 17,  0, 18, 11, 18, 11,
  9,  0, 15,  0,  3,  8, 10,
  3,  6,  1, 16,  0, 13, 10,
 15, 20,  2,  6, 18,  0,  9,
  4,  6,  8, 13, 16, 10,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): maxflow;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define maxflow as net flow out of source
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% (Optional but consistent) net flow into sink equals maxflow
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = \(maxflow)\n"];