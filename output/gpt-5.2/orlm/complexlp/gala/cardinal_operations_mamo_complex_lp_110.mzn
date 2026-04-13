include "globals.mzn";

% Max-flow from source s=0 to sink t=5 on a directed graph with capacities.
% Data is embedded directly as requested.

int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

array[N, N] of int: cap =
%   to:  0  1  2  3  4  5
[|      0, 6, 8, 1, 9, 8   % from 0
 |     16, 0, 6, 0,12,16   % from 1
 |      7,16, 0,20,17, 9   % from 2
 |      3,11,14, 0, 7, 0   % from 3
 |      6,19,19, 3, 0,20   % from 4
 |     20, 5,16,12, 2, 0   % from 5
 |];

% Decision variables: flow on each arc (i -> j)
array[N, N] of var 0..20: f; % upper bound 20 is safe since all capacities <= 20

% Capacity + no-self-flow
constraint forall(i, j in N)(
  (i = j -> f[i,j] = 0) /\
  (i != j -> f[i,j] <= cap[i,j])
);

% Flow conservation at intermediate nodes
constraint forall(v in N where v != s /\ v != t)(
  sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
);

% Maximize total outflow from source (equivalently inflow to sink by conservation)
var 0..1000: totalFlow = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);
constraint totalFlow = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

solve maximize totalFlow;

output [
  "Maximum flow (thousand tons/day) = ", show(totalFlow), "\n",
  "Flow matrix f[from,to]:\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in N ]) ++ "\n" | i in N ])
];