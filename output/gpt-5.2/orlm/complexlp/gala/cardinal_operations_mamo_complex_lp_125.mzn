include "globals.mzn";

% Max flow from source s=0 to sink t=8 on a directed network with capacities.
% Nodes are 0..8 (9 nodes). Capacities are in thousands of gallons per hour.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
%      to:  0   1   2   3   4   5   6   7   8
 [|        0,  5,  2,  7, 17,  4,  1,  2, 13   % from 0
  |       12,  0, 15, 18,  8,  9,  8,  1, 15   % from 1
  |       17, 16,  0, 20, 17, 13,  2, 19,  6   % from 2
  |        5,  9, 14,  0, 10, 18, 20,  9, 18   % from 3
  |       12, 14,  7,  6,  0,  6, 17,  4,  9   % from 4
  |       12, 11, 10,  1, 13,  0, 14, 12, 14   % from 5
  |       13,  7,  3,  9,  1, 14,  0,  7, 16   % from 6
  |       18, 15,  8,  0, 12, 13,  5,  0, 17   % from 7
  |        3, 11, 15, 14,  0,  4, 18, 16,  0   % from 8
 |];

int: U = sum(i in V)(cap[s,i]); % simple safe upper bound on max flow

array[V, V] of var 0..U: f;     % flow on each directed arc

% Capacity constraints (also forces f[i,j]=0 if cap[i,j]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Define total flow value as net outflow from source (equivalently net inflow to sink)
var 0..U: F;
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [
  "Maximum flow (thousand gallons/hour) = ", show(F), "\n",
  "Flow matrix f[from,to] =\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j])
                    | j in V ]) ++ "\n"
           | i in V ])
];