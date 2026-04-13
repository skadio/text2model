% Parameters
int: N = 4;
set of int: V = 1..N;

array[V, V] of int: cap =
  array2d(V, V,
  [ 0, 5, 7, 0,
    0, 0, 2, 4,
    0, 0, 0, 12,
    0, 0, 0, 0 ]);

int: s = 1;
int: t = 4;

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: totalOutS = sum(j in V)(cap[s,j]);
int: UB = max(totalOutS, maxCap);

% Variables
array[V, V] of var 0..UB: f;
var 0..totalOutS: maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;