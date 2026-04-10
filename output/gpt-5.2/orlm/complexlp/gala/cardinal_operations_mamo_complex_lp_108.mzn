include "globals.mzn";

% Max-flow from source (0) to sink (7) on a directed capacitated graph with 8 nodes.

int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

% Capacity matrix cap[i,j] (MW). 0 means no arc.
array[V, V] of int: cap =
array2d(V, V,
[
  % to: 0  1  2  3  4  5  6  7   from:
       0, 9, 6, 1, 8,14, 1,17,    % 0
       1, 0, 6,14,16, 8,19,15,    % 1
       4, 7, 0, 9, 1, 2, 9, 4,    % 2
      11, 5,14, 0,17, 6,20,13,    % 3
       8, 5,20, 0, 0,16, 5, 5,    % 4  (4->3 is 0; 4->4 is 0)
      15,18, 9, 1,19, 0,16, 0,    % 5
      20,15, 1, 0,11, 6, 0,19,    % 6
       4,18,10, 2, 1,20,14, 0     % 7
]);

% Decision variables: flow on each possible arc.
% We allow variables for all pairs, and force them within capacity (0 => must be 0).
array[V, V] of var 0..20: f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes (not source/sink):
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow out of source (equivalently net into sink).
var int: maxFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxFlow;

output [
  "Maximum flow (MW) = ", show(maxFlow), "\n",
  "Flow matrix f[from,to] (rows=from 0..7):\n",
  concat([ concat([ show(f[i,j]) ++ if j==N-1 then "\n" else "\t" endif
                   | j in V ])
          | i in V ])
];