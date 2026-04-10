% Parameters (with values embedded)
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
[|  0, 11,  8, 11, 20, 16
 | 15,  0, 11, 16,  0, 20
 |  7,  4,  0,  4, 11,  0
 |  4,  8, 14,  0, 19,  0
 | 10,  0,  6, 19,  0, 13
 | 10, 15, 20, 19, 10,  0 |];

% Variables
array[V, V] of var 0..20: f;   % flow on each directed arc (bounded by max capacity 20)
var 0..100: maxflow;           % total flow from source to destination (safe upper bound)

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define maxflow as net outflow from source (equivalently net inflow to sink)
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;