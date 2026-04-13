% Shortest path from S to T (nodes: 1=S, 2..7, 8=T)

int: N = 8;
set of int: V = 1..N;
int: S = 1;
int: T = 8;

array[V, V] of int: W =
[| 0, 4, 5, 0, 0, 0, 0, 0
 | 5, 0, 2, 3, 0, 0, 0, 0
 | 4, 2, 0, 0, 1, 7, 0, 0
 | 0, 3, 0, 0, 0, 2, 0, 0
 | 0, 0, 1, 0, 0, 0, 0, 5
 | 0, 0, 7, 2, 0, 0, 3, 0
 | 0, 0, 0, 0, 0, 3, 0, 1
 | 0, 0, 0, 0, 5, 0, 1, 0 |];

% Build edge list explicitly (MiniZinc does not support "set of (int,int)")
int: M = sum(i in V, j in V)( if W[i,j] > 0 then 1 else 0 endif );

array[1..M] of int: E_from =
  [ i | i in V, j in V where W[i,j] > 0 ];
array[1..M] of int: E_to =
  [ j | i in V, j in V where W[i,j] > 0 ];
array[1..M] of int: E_w =
  [ W[i,j] | i in V, j in V where W[i,j] > 0 ];

int: INF = 1000000;

array[V] of var 0..INF: dist;

constraint dist[S] = 0;

% Relaxation constraints (Bellman-Ford style)
constraint forall(e in 1..M)(
  dist[E_to[e]] <= dist[E_from[e]] + E_w[e]
);

solve minimize dist[T];

output ["Shortest distance S->T = ", show(dist[T]), " meters\n"];