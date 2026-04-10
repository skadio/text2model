% Max flow from s to t with given capacities (embedded)
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix (coerced to index set 0..8 x 0..8)
array[V, V] of int: cap = array2d(V, V, [
  0,  6, 20, 15,  9, 20, 17, 16, 20,
  6,  0, 18, 13,  9,  8, 15, 10, 10,
  20, 18,  0,  3, 19,  7, 14,  4,  2,
  15, 13,  3,  0,  6, 12,  8, 17, 20,
  9,  9, 19,  6,  0, 18, 13,  6,  1,
  20,  8,  7, 12, 18,  0, 19,  9,  9,
  17, 15, 14,  8, 13, 19,  0,  6,  9,
  16, 10,  4, 20,  6,  9,  6,  0,  8,
  20, 10,  2, 20,  1,  9,  9,  8,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Flow variables
array[V, V] of var 0..U: f;

% Total s->t flow (upper bound: total outgoing capacity from s)
var 0..sum(j in V)(cap[s,j]): flow;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective flow as net outflow from source (equivalently net inflow to sink)
constraint flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize flow;

output ["max_flow = ", show(flow), "\n"];