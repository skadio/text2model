% Parameters
int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  0,  5, 16, 11,  2, 10, 17,  2,
  8,  0, 14, 14,  2,  7, 11,  1,
 17, 20,  0, 16, 13,  0,  6,  1,
  3, 16, 10,  0, 19, 12,  3, 15,
 15, 12, 19, 18,  0, 14, 12, 15,
  2, 20, 20, 17,  4,  0, 10, 17,
 15, 13, 13,  5, 10, 15,  0, 19,
 10,  3, 14, 11,  5, 20,  4,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(sum(j in V)(cap[s,j])): total_flow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V) (
    f[i,i] = 0
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

constraint
  total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Objective
solve maximize total_flow;