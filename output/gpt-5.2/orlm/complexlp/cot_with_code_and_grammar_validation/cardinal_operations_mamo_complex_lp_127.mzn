% Max Flow problem (source s=0 to sink t=8)

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix (cap[i,j] = capacity from i to j)
array[V, V] of int: cap =
array2d(V, V, [
  0, 13, 19, 17,  7,  7, 11,  7,  7,
  9,  0, 19, 20, 10, 19, 20, 19,  3,
  0, 16,  0,  0, 10,  2, 14,  9,  9,
  6,  0,  5,  0,  7, 18, 15, 20,  7,
 18, 19, 12,  0,  0, 16, 20, 10,  4,
  3,  4,  8,  9, 20,  0,  7,  8,  1,
  3, 14, 14, 16,  1, 12,  0, 10, 10,
  9, 20, 19,  4,  9, 16,  1,  0,  6,
  7, 15, 14, 18, 18, 11, 18,  0,  0
]);

int: totalCap = sum(i,j in V where i != j)(cap[i,j]);

% Flow variables
array[V, V] of var 0..totalCap: f;
var 0..totalCap: maxflow;

% No self-flow
constraint forall(i in V)(f[i,i] = 0);

% Capacity constraints (forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i,j in V where i != j)(f[i,j] <= cap[i,j]);

% Flow conservation for intermediate nodes
constraint
  forall(v in V where v != s /\ v != t)(
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

% Define maxflow by net outflow at source and net inflow at sink
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output [
  "maxflow = ", show(maxflow), "\n"
];