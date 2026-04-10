include "globals.mzn";

% Shortest path from S to T in a directed weighted graph (data embedded)

% Node indexing:
% 1 = S, 2..7 = nodes 2..7, 8 = T
int: N = 8;
int: S = 1;
int: T = 8;

set of int: V = 1..N;

% Large constant for "no edge"
int: INF = 1000000;

% Distance (weight) matrix w[i,j] (INF means no direct arc)
array[V, V] of int: w =
  array2d(V, V,
  [
    % to:  1(S)   2     3     4     5     6     7     8(T)
    /*1*/   INF,   4,    5,   INF,  INF,  INF,  INF,  INF,
    /*2*/     5,  INF,   2,    3,   INF,  INF,  INF,  INF,
    /*3*/     4,    2,  INF,  INF,    1,    7,  INF,  INF,
    /*4*/   INF,   3,  INF,  INF,  INF,    2,  INF,  INF,
    /*5*/   INF, INF,    1,  INF,  INF,  INF,  INF,    5,
    /*6*/   INF, INF,    7,    2,  INF,  INF,    3,  INF,
    /*7*/   INF, INF,  INF,  INF,  INF,    3,  INF,    1,
    /*8*/   INF, INF,  INF,  INF,    5,  INF,    1,  INF
  ]);

% Decision variables: distances from S to each node
array[V] of var 0..INF: d;

% Fix distance at source
constraint d[S] = 0;

% Bellman-Ford style relaxation: for all arcs i->j, d[j] <= d[i] + w[i,j]
constraint forall(i in V, j in V where w[i,j] < INF) (
  d[j] <= d[i] + w[i,j]
);

% We want the smallest feasible distance to T
solve minimize d[T];

output [
  "Shortest distance S->T = ", show(d[T]), " meters\n"
];