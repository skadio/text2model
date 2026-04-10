% Shortest path from S to T in a weighted graph
% Node indexing: 1 = S, 2..7 correspond to nodes 2..7, 8 = T

int: nNodes = 8;
set of int: NODES = 1..nNodes;

int: S = 1;
int: T = 8;

% Directed edges (both directions where given)
int: nEdges = 18;
set of int: EDGES = 1..nEdges;

array[EDGES] of int: from = [
  1, 1,        % S->2, S->3
  2, 2, 2,     % 2->S, 2->4, 2->3
  3, 3, 3, 3,  % 3->S, 3->2, 3->5, 3->6
  4, 4,        % 4->2, 4->6
  5, 5,        % 5->3, 5->T
  6, 6, 6,     % 6->3, 6->4, 6->7
  7, 7,        % 7->6, 7->T
  8, 8         % T->5, T->7
];

array[EDGES] of int: to = [
  2, 3,
  1, 4, 3,
  1, 2, 5, 6,
  2, 6,
  3, 8,
  3, 4, 7,
  6, 8,
  5, 7
];

array[EDGES] of int: w = [
  5, 4,
  5, 3, 2,
  4, 2, 1, 7,
  3, 2,
  1, 5,
  7, 2, 3,
  3, 1,
  5, 1
];

int: maxW = max(w);
int: UB_dist = maxW * (nNodes - 1);

% Variables: distance labels
array[NODES] of var 0..UB_dist: dist;
var 0..UB_dist: shortest_ST = dist[T];

% Constraints
constraint dist[S] = 0;

% Potential constraints: for all edges u->v, dist[v] <= dist[u] + w
constraint forall(e in EDGES) (
  dist[to[e]] <= dist[from[e]] + w[e]
);

% Objective
solve minimize shortest_ST;

output [
  "shortest_distance_S_to_T = ", show(shortest_ST), "\n",
  "dist = ", show(dist), "\n"
];