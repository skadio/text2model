% Shortest path from S to T (nodes: 1=S, 2..7, 8=T)

int: N = 8;
int: S = 1;
int: T = 8;

set of int: V = 1..N;

array[V, V] of int: w = array2d(V, V,
[
  %      1  2  3  4  5  6  7  8
  /*1*/  0, 5, 4, 0, 0, 0, 0, 0,
  /*2*/  5, 0, 2, 3, 0, 0, 0, 0,
  /*3*/  4, 2, 0, 0, 1, 7, 0, 0,
  /*4*/  0, 3, 0, 0, 0, 2, 0, 0,
  /*5*/  0, 0, 1, 0, 0, 0, 0, 5,
  /*6*/  0, 0, 7, 2, 0, 0, 3, 0,
  /*7*/  0, 0, 0, 0, 0, 3, 0, 1,
  /*8*/  0, 0, 0, 0, 5, 0, 1, 0
]);

int: INF = 1000000;

% Distance variables
array[V] of var 0..INF: dist;

% Bellman-Ford style relaxation constraints (feasibility region for shortest paths)
constraint dist[S] = 0;

constraint forall(i in V, j in V where w[i,j] > 0) (
  dist[j] <= dist[i] + w[i,j]
);

solve minimize dist[T];

output [
  "Shortest distance S->T = ", show(dist[T]), "\n"
];