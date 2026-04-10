% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V, [
  0, 11,  8, 11, 20, 16,
 15,  0, 11, 16,  0, 20,
  7,  4,  0,  4, 11,  0,
  4,  8, 14,  0, 19,  0,
 10,  0,  6, 19,  0, 13,
 10, 15, 20, 19, 10,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: UB = (N-1) * maxCap; % safe upper bound on total flow

% Variables
array[V, V] of var 0..maxCap: f;     % flow on each directed arc
var 0..UB: F;                         % total s->t flow value

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (net outflow - inflow = b[v])
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define total flow value from source and into sink
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;