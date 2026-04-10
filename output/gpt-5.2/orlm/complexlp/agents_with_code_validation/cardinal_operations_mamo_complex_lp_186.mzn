% Parameters
% Nodes are indexed as:
% 1 = S (start), 2..7 = intermediate nodes, 8 = T (target)
int: nNodes = 8;
set of int: N = 1..nNodes;

int: S = 1;
int: T = 8;

% A large number representing "no direct edge"
int: INF = 10^6;

% Distance/weight matrix (directed). Use INF when no edge exists.
array[N, N] of int: w =
  array2d(N, N,
  [
    % to:  1     2     3     4     5     6     7     8
    /*1*/  0,    4,    5,  INF,  INF,  INF,  INF,  INF,
    /*2*/  5,    0,    2,    3,  INF,  INF,  INF,  INF,
    /*3*/  4,    2,    0,  INF,    1,    7,  INF,  INF,
    /*4*/INF,    3,  INF,    0,  INF,    2,  INF,  INF,
    /*5*/INF,  INF,    1,  INF,    0,  INF,  INF,    5,
    /*6*/INF,  INF,    7,    2,  INF,    0,    3,  INF,
    /*7*/INF,  INF,  INF,  INF,  INF,    3,    0,    1,
    /*8*/INF,  INF,  INF,  INF,    5,  INF,    1,    0
  ]);

% Derived bound on shortest-path length (simple safe upper bound)
int: maxEdge = 7;
int: UB = (nNodes - 1) * maxEdge;

% Variables
array[N] of var 0..UB: dist;      % shortest distance estimate from S to each node
var 0..UB: shortest_distance;     % shortest distance from S to T


% Constraints

% --- Source distance fixed ---
constraint dist[S] = 0;

% --- Relaxation constraints for all directed edges (Bellman-Ford style) ---
% If there is a direct edge i->j (w[i,j] < INF), then dist[j] <= dist[i] + w[i,j].
constraint
  forall(i in N, j in N where w[i,j] < INF) (
    dist[j] <= dist[i] + w[i,j]
  );

% --- Target distance extraction ---
constraint shortest_distance = dist[T];


% Objective
solve minimize shortest_distance;