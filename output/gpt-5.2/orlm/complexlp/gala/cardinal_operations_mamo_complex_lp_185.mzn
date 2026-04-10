include "globals.mzn";

/*
  Shortest path from S to T in the given undirected weighted graph.

  Node mapping:
    1 = S
    2..7 = nodes 2..7
    8 = T
*/

int: N = 8;
int: S = 1;
int: T = 8;

set of int: V = 1..N;

/* Large number for "no edge" */
int: INF = 10_000;

/* Distance/weight matrix (undirected) */
array[V, V] of int: w =
  array2d(V, V, [
    % 1   2   3   4   5   6   7   8
      0,  5,  4, INF,INF,INF,INF,INF,  % 1=S
      5,  0,  2,  3, INF,INF,INF,INF,  % 2
      4,  2,  0, INF,  1,  7, INF,INF,  % 3
    INF,  3, INF,  0, INF,  2, INF,INF,  % 4
    INF,INF,  1, INF,  0, INF,INF,  5,  % 5
    INF,INF,  7,  2, INF,  0,  3, INF,  % 6
    INF,INF,INF,INF,INF,  3,  0,  1,  % 7
    INF,INF,INF,INF,  5, INF,  1,  0   % 8=T
  ]);

/* Decision variables: choose a directed S->T path using arcs x[i,j] */
array[V, V] of var 0..1: x;

/* No self loops and only allow existing edges */
constraint forall(i in V)(x[i,i] = 0);
constraint forall(i,j in V where i != j)(
  (w[i,j] >= INF) -> (x[i,j] = 0)
);

/* Flow constraints for a single S->T path */
constraint sum(j in V)(x[S,j]) - sum(j in V)(x[j,S]) = 1;
constraint sum(j in V)(x[T,j]) - sum(j in V)(x[j,T]) = -1;
constraint forall(v in V where v != S /\ v != T)(
  sum(j in V)(x[v,j]) - sum(j in V)(x[j,v]) = 0
);

/* Degree limits to prevent branching (simple path structure) */
constraint forall(v in V where v != T)(sum(j in V)(x[v,j]) <= 1);
constraint forall(v in V where v != S)(sum(j in V)(x[j,v]) <= 1);

/* Subtour elimination via MTZ order variables */
array[V] of var 0..N: u;
constraint u[S] = 1;
constraint u[T] >= 1;
constraint forall(v in V where v != S)(u[v] >= 2);
constraint forall(v in V)(u[v] <= N);

constraint forall(i,j in V where i != j /\ w[i,j] < INF)(
  x[i,j] = 1 -> u[j] >= u[i] + 1
);

/* Objective: minimize total distance */
var int: dist = sum(i,j in V)(x[i,j] * w[i,j]);

solve minimize dist;

/* Output: shortest distance rounded to nearest meter (weights are already integers) */
output [
  "Shortest distance S->T (meters) = ", show(dist), "\n",
  "Selected arcs (i->j): ",
  show([ (i,j) | i,j in V where fix(x[i,j]) = 1 ]),
  "\n"
];