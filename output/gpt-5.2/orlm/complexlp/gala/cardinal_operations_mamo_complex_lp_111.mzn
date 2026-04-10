% Max flow problem: source = 0, sink = 7, 8 nodes total.
include "globals.mzn";

int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

% Capacity matrix cap[u,v] (0 means no arc). Embedded from description.
array[V, V] of int: cap =
array2d(V, V,
[
  % to: 0  1  2  3  4  5  6  7   from:
     0,19, 4, 1, 9,13, 8,20,     % 0
    10, 0,12,12, 8,12, 7, 7,     % 1
    13,11, 0, 8, 4, 1, 2, 3,     % 2
     4,12,13, 0,18, 6,19, 8,     % 3
     9,16, 2, 0, 0,14,18, 7,     % 4 (no 4->3 given => 0; 4->4 = 0)
    10,11, 7,11,16, 0,16, 5,     % 5
    14,11, 9,11, 3,17, 0,19,     % 6
    12,20, 5,11,10, 4, 6, 0      % 7
]);

% Flow on every potential arc (including those with 0 capacity, forced to 0 by constraints)
array[V, V] of var 0..max(cap): f;

% Capacity constraints
constraint forall(u,v in V) (
  f[u,v] <= cap[u,v]
);

% No self flow
constraint forall(i in V)( f[i,i] = 0 );

% Flow conservation (excluding source and sink)
constraint forall(i in V where i != s /\ i != t) (
  sum(u in V)(f[u,i]) = sum(v in V)(f[i,v])
);

% Objective: maximize total flow into sink (equivalently out of source)
var 0..sum(u in V)(cap[u,t]): maxFlow = sum(u in V)(f[u,t]);
constraint maxFlow = sum(v in V)(f[s,v]); % consistency

solve maximize maxFlow;

output [
  "Maximum flow from ", show(s), " to ", show(t), " = ", show(maxFlow), "\n",
  "Flow matrix f[u,v]:\n",
  concat([ concat([ if v==0 then "" else " " endif ++ show(f[u,v]) | v in V ]) ++ "\n" | u in V ])
];