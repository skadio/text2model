% Parameters (with values embedded)
int: N = 8; % 1=S, 8=T, nodes 2..7 are intermediate
int: S = 1;
int: T = 8;

array[1..N, 1..N] of int: w =
%    1  2  3  4  5  6  7  8
[|  0, 4, 5, 0, 0, 0, 0, 0 |  % 1 = S
 |  5, 0, 2, 3, 0, 0, 0, 0 |  % 2
 |  4, 2, 0, 0, 1, 7, 0, 0 |  % 3
 |  0, 3, 0, 0, 0, 2, 0, 0 |  % 4
 |  0, 0, 1, 0, 0, 0, 0, 5 |  % 5
 |  0, 0, 7, 2, 0, 0, 3, 0 |  % 6
 |  0, 0, 0, 0, 0, 3, 0, 1 |  % 7
 |  0, 0, 0, 0, 5, 0, 1, 0 |  % 8 = T
|];

set of int: V = 1..N;
set of int: E = { (i,j) | i,j in V where w[i,j] > 0 };

int: INF = 1000000;
int: UB = 1000; % safe upper bound on shortest path length in this small graph

% Variables
array[V] of var 0..UB: dist;

% Constraints
constraint dist[S] = 0;

constraint
  forall(i in V where i != S) (
    dist[i] >= 0
  );

% Bellman-Ford style inequalities: for every directed edge (i->j),
% dist[j] <= dist[i] + w[i,j]
constraint
  forall(i,j in E) (
    dist[j] <= dist[i] + w[i,j]
  );

% Objective
solve minimize dist[T];

output [
  "Shortest distance S->T (rounded to nearest meter): ",
  show(dist[T]),
  " m\n"
];