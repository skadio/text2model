include "globals.mzn";

% Max-flow from source 0 to sink 8 on a directed capacitated network of 9 nodes.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
  [| 0, 0, 20, 10, 0,  2, 11,  5, 12   % from 0
   | 7, 0,  5,  9, 9, 16,  1, 17,  7   % from 1
   | 3,17,  0,  1, 5, 18, 13, 12, 14   % from 2
   | 9,10,  2,  0,10, 11, 11,  5, 10   % from 3
   | 7, 5,  1, 19, 0, 19, 12, 14, 15   % from 4
   |16, 4,  6, 15,19,  0,  0,  0, 20   % from 5
   | 3, 0, 17, 16,19,  8,  0,  8,  9   % from 6
   |14,11, 13, 17,10, 13, 20,  0, 16   % from 7
   |20, 5, 20, 16, 0, 15,  1, 12,  0   % from 8
  |];

% Upper bound on total flow: sum of outgoing capacities from source (safe bound)
int: UB = sum(j in V)(cap[s,j]);

% Decision variables: flow on each arc
array[V, V] of var 0..UB: f;

% Capacity constraints (and force f=0 where no arc / self-loops)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Maximize net flow into sink (equivalently out of source)
var 0..UB: maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow = ", show(maxflow), "\n",
  "Flow matrix f[i,j] (i=0..8 rows):\n",
  concat([ concat([ if j=0 then "" else " " endif ++
                    show(f[i,j]) | j in V ]) ++ "\n"
         | i in V ])
];