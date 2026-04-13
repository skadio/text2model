% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: source = 0;
int: sink   = 6;

array[V, V] of int: cap =
array2d(V, V, [
  0, 20, 19, 18,  0, 11,  2,
  18,  0, 15, 10,  0,  9,  0,
  18,  4,  0, 11, 15,  0, 13,
  17,  3, 15,  0,  2,  4,  4,
   2, 11, 17, 17,  0,  2, 17,
  12,  4, 16, 13,  5,  0,  3,
   7,  9, 17, 18, 16,  8,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(sum(j in V)(cap[source,j])): total_flow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V)(f[i,i] = 0);

constraint
  forall(v in V where v != source /\ v != sink) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

constraint
  total_flow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

constraint
  total_flow = sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]);

% Objective
solve maximize total_flow;