% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
  array2d(V, V,
  [
    0, 11,  8, 11, 20, 16,
   15,  0, 11, 16,  0, 20,
    7,  4,  0,  4, 11,  0,
    4,  8, 14,  0, 19,  0,
   10,  0,  6, 19,  0, 13,
   10, 15, 20, 19, 10,  0
  ]);

int: cap_ub = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..cap_ub: f;
var 0..sum(j in V)(cap[s,j]): maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(n in V where n != s /\ n != t) (
    sum(i in V)(f[i,n]) = sum(j in V)(f[n,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;