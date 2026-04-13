% Maximum flow from source s to sink t in a directed capacitated network

% Parameters
int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

% Capacities (embedded data). Use array2d to match index set 0..5 x 0..5.
array[V, V] of int: cap = array2d(V, V, [
   0,  4, 12, 19, 13, 11,
  20,  0, 13,  9, 10,  0,
  14,  8,  0,  5, 13, 11,
   5, 15, 18,  0,  6,  7,
   8, 17, 20, 14,  0,  9,
   0,  0,  0,  0,  0,  0
]);

int: U  = max([cap[i,j] | i in V, j in V]);
int: UB = sum([cap[s,j] | j in V]); % simple upper bound on max flow

% Variables
array[V, V] of var 0..U: f;  % flow on each directed arc
var 0..UB: F;                % total flow value

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (except at source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective flow value (net outflow from source = net inflow to sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output ["Max flow = ", show(F), "\n"];