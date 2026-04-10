% Parameters
% Node indexing: 1=S, 2..7 are numbered nodes, 8=T
int: nNodes = 8;
set of int: NODES = 1..nNodes;

int: S = 1;
int: T = 8;

% Directed arc set derived from the described (undirected) edges
int: nArcs = 20;
set of int: ARCS = 1..nArcs;

array[ARCS] of int: from = [
  1, 2,  1, 3,  % S<->2, S<->3
  2, 4,  4, 2,  % 2<->4
  2, 3,  3, 2,  % 2<->3
  3, 5,  5, 3,  % 3<->5
  3, 6,  6, 3,  % 3<->6
  4, 6,  6, 4,  % 4<->6
  6, 7,  7, 6,  % 6<->7
  5, 8,  8, 5,  % 5<->T
  7, 8,  8, 7   % 7<->T
];

array[ARCS] of int: to = [
  2, 1,
  3, 1,
  4, 2,
  2, 4,
  3, 2,
  2, 3,
  5, 3,
  3, 5,
  6, 3,
  3, 6,
  6, 4,
  4, 6,
  7, 6,
  6, 7,
  8, 5,
  5, 8,
  8, 7,
  7, 8
];

array[ARCS] of int: w = [
  4, 5,
  5, 4,
  3, 3,
  2, 2,
  1, 1,
  7, 7,
  2, 2,
  3, 3,
  5, 5,
  1, 1
];

int: maxW = max(w);
int: maxDist = maxW * (nNodes - 1); % safe upper bound for shortest-path distances

% Variables
% Distance (in meters) from S to each node (nonnegative, bounded)
array[NODES] of var 0..maxDist: dist;

% x[a]=1 if arc a is chosen in the (single) S->T path, else 0
array[ARCS] of var 0..1: x;

% Constraints

% Fix the source distance
constraint dist[S] = 0;

% Shortest-path relaxation constraints (Bellman-Ford style):
% For every directed arc (u -> v) with weight w[a]:
%   dist[v] <= dist[u] + w[a]
constraint
  forall(a in ARCS) (
    dist[to[a]] <= dist[from[a]] + w[a]
  );

% Flow conservation to ensure x forms one unit of flow from S to T
constraint
  forall(i in NODES) (
    (sum(a in ARCS where from[a] = i)(x[a]) - sum(a in ARCS where to[a] = i)(x[a])) =
    (if i = S then 1 else if i = T then -1 else 0 endif endif)
  );

% Link selected arcs to distances using big-M:
% If x[a]=1 then dist[to[a]] = dist[from[a]] + w[a]
constraint
  forall(a in ARCS) (
    dist[to[a]] >= dist[from[a]] + w[a] - maxDist * (1 - x[a])
  );

constraint
  forall(a in ARCS) (
    dist[to[a]] <= dist[from[a]] + w[a] + maxDist * (1 - x[a])
  );

% Ensure exactly one selected incoming arc to T (redundant but clarifying)
constraint sum(a in ARCS where to[a] = T)(x[a]) = 1;

% Objective
solve minimize dist[T];