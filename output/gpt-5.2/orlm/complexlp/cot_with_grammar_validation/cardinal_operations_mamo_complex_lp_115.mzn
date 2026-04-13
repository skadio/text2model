% Parameters
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
  array2d(V, V,
  [ 0,20,19,18, 0,11, 2,
   18, 0,15,10, 0, 9, 0,
   18, 4, 0,11,15, 0,13,
   17, 3,15, 0, 2, 4, 4,
    2,11,17,17, 0, 2,17,
   12, 4,16,13, 5, 0, 3,
    7, 9,17,18,16, 8, 0 ]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(N*maxCap): totalFlow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != s /\ k != t) (
    sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
  );

constraint
  totalFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  totalFlow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize totalFlow;