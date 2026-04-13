% Max flow from node 0 (source) to node 7 (sink) in a directed network
% Data embedded as requested.

include "globals.mzn";

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
%    to:  0  1  2  3  4  5  6  7
  [|     0, 3, 3, 5,13, 7,14,17   % from 0
   |     5, 0, 0, 2,18,20, 1,17   % from 1
   |     2,18, 0,10,14,15, 8,18   % from 2
   |    20, 7,11, 0,13, 2, 8,12   % from 3
   |    20,20,12, 7, 0,11, 2,14   % from 4
   |     5,16,15,19,11, 0, 1, 8   % from 5
   |    10, 3,14,18,13, 6, 0, 7   % from 6
   |     9, 3,14,13, 6, 5, 9, 0   % from 7
  |];

% Flow on each directed arc
array[V, V] of var 0..max(cap): f;

% Capacity constraints (also forces f=0 when cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize total flow out of source (equivalently into sink)
var 0..sum(j in V)(cap[s,j]): maxFlow = sum(j in V)(f[s,j]);
constraint maxFlow = sum(i in V)(f[i,t]);

solve maximize maxFlow;

output [
  "Maximum flow (Tbps) = ", show(maxFlow), "\n",
  "Flow matrix f[from,to]:\n",
  show(f), "\n"
];