% Parameters
int: N = 4;
set of int: V = 1..N;

int: source = 1;
int: sink = 4;

array[V, V] of int: cap = array2d(V, V, [
  0, 8, 7, 0,
  0, 0, 2, 4,
  0, 0, 0, 7,
  0, 0, 0, 0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(N * maxCap): totalFlow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != source /\ k != sink) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

constraint
  totalFlow = sum(j in V)(f[source,j]);

constraint
  totalFlow = sum(i in V)(f[i,sink]);

% Objective
solve maximize totalFlow;