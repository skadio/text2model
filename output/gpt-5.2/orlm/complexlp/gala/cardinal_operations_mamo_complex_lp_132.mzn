include "globals.mzn";

% Max flow from source (0) to sink (7) on a directed network of 8 nodes.

int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
%    0  1  2  3  4  5  6  7
[|  0, 2, 1, 1, 8,17, 6, 7   % from 0
 |  4, 0,14,14,13,19, 4,19   % from 1
 |  6,16, 0, 3,10, 7,18,10   % from 2
 | 19, 4,15, 0, 6, 1,17, 9   % from 3
 | 12,15, 3,14, 0,18,20,14   % from 4
 | 20, 5,19, 9,20, 0,10, 6   % from 5
 |  9,14,12,16,19, 3, 0,10   % from 6
 | 20,16, 6,16, 8,16, 4, 0   % from 7
 |];

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Flow variables on all arcs (i,j). If cap[i,j]=0, flow is forced to 0.
array[V, V] of var 0..maxCap: f;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow out of source (equivalently into sink)
var 0..sum(j in V)(cap[s,j]): totalFlow;
constraint totalFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize totalFlow;

output [
  "Maximum flow (thousand kW/h) = ", show(totalFlow), "\n",
  "Flow matrix f[i,j] (i rows 0..7):\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j])
                    | j in V ]) ++ "\n"
           | i in V ])
];