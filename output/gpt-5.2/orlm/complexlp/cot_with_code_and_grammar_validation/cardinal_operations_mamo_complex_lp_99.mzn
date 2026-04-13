% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
  array2d(V, V,
  [ 0,14, 9, 8, 7, 8,
    4, 0, 9,10, 0,12,
    4,12, 0,13,20,16,
   10, 8,12, 0, 0,18,
    3,13,11,20, 0, 2,
   17, 4, 8, 2,12, 0 ]);

int: maxCapOutS = sum(j in V where j != s)(cap[s,j]);

% Variables
array[V, V] of var 0..maxCapOutS: f;  % flow on arc i->j
var 0..maxCapOutS: F;                 % total s->t flow value

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V, j in V) (
  (cap[i,j] = 0) -> (f[i,j] = 0)
);

constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint forall(k in V where k != s /\ k != t) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

constraint sum(j in V)(f[t,j]) - sum(i in V)(f[i,t]) = -F;

% Objective
solve maximize F;