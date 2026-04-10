% Parameters
int: N = 8; % 1=S, 2..7=nodes, 8=T
int: S = 1;
int: T = 8;

set of int: V = 1..N;

int: M = 18; % directed arcs (both directions for each undirected edge)
set of int: A = 1..M;

array[A] of int: tail = [1,1, 2,2,2, 3,3,3,3, 4,4, 5,5, 6,6,6, 7,7];
array[A] of int: head = [2,3, 1,4,3, 1,2,5,6, 2,6, 3,8, 3,4,7, 6,8];
array[A] of int: w    = [5,4, 5,3,2, 4,2,1,7, 3,2, 1,5, 7,2,3, 3,1];

int: Wsum = sum(a in A)(w[a]);

% Variables
array[A] of var 0..1: x;          % 1 if arc a is used in the path
array[V] of var -1..1: b;         % flow balance at nodes
array[V] of var 0..N: order;      % MTZ order to prevent cycles (path)

var 0..Wsum: dist;

% Constraints
constraint b[S] = 1;
constraint b[T] = -1;
constraint forall(v in V where v != S /\ v != T)(b[v] = 0);

constraint forall(v in V)(
  sum(a in A where head[a] = v)(x[a]) - sum(a in A where tail[a] = v)(x[a]) = b[v]
);

% Each node has at most one outgoing/incoming arc in the selected path
constraint forall(v in V)(sum(a in A where tail[a] = v)(x[a]) <= 1);
constraint forall(v in V)(sum(a in A where head[a] = v)(x[a]) <= 1);

% Ensure S has exactly one outgoing and T has exactly one incoming on the path
constraint sum(a in A where tail[a] = S)(x[a]) = 1;
constraint sum(a in A where head[a] = T)(x[a]) = 1;

% MTZ subtour elimination / enforce simple path structure
constraint order[S] = 0;
constraint forall(v in V where v != S)(order[v] >= 1);
constraint forall(a in A where tail[a] != T /\ head[a] != S)(
  order[head[a]] >= order[tail[a]] + 1 - N * (1 - x[a])
);

% Distance
constraint dist = sum(a in A)(w[a] * x[a]);

% Objective
solve minimize dist;