% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 8;

array[V, V] of int: cap =
[| 0,14,20, 7, 9, 1, 4, 8,19
 | 3, 0,15,12,17, 0,15, 3, 3
 |11, 8, 0, 1,19,16, 5, 1, 2
 |13,13, 2, 0,16,20,16,17, 3
 | 6,15, 7, 3, 0,18, 1, 3, 9
 |15,20, 8, 4, 6, 0, 3, 1, 4
 | 5,15,19, 4,15,12, 0, 3, 8
 | 7,14,13,12, 9,10, 3, 0, 4
 | 3,12, 6, 6, 1,11, 6, 1, 0 |];

% Variables
array[V, V] of var 0..20: f;

% Constraints
constraint forall(i,j in V where i != j) (
  f[i,j] <= cap[i,j]
);
constraint forall(i in V) ( f[i,i] = 0 );

% Flow conservation (only enforce at intermediate nodes)
constraint forall(v in V where v != source /\ v != sink) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective
var 0..200: total_flow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);
constraint total_flow = sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]);

solve maximize total_flow;