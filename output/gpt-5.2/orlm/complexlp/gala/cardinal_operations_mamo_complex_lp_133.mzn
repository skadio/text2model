% Max flow from node 0 (source) to node 8 (sink) with given capacities.
include "globals.mzn";

int: n = 9;
set of int: N = 0..n-1;
int: s = 0;
int: t = 8;

% Capacity matrix c[i,j] (Tbps). 0 means no direct link.
array[N, N] of int: c =
%      0  1  2  3  4  5  6  7  8
[|     0, 6,20,15, 9,20,17,16,20  % from 0
 |     0, 0, 0, 0, 0, 0, 0, 0, 0  % from 1 (not fully specified in prompt)
 |     0, 0, 0, 0,19, 0, 0, 0, 0  % from 2 (only stated max 19 to 4)
 |     0, 0, 0, 0, 0, 0, 0, 0,20  % from 3 (stated 20 to 8)
 |     0, 0, 0, 0, 0, 0, 0, 0, 0  % from 4 (unspecified)
 |     0, 0, 0, 0, 0, 0, 0, 0, 0  % from 5 (unspecified)
 |     0, 0, 0, 0, 0, 0, 0, 0, 0  % from 6 (unspecified)
 |     0, 0, 0,20, 0, 0, 0, 0, 0  % from 7 (stated 20 to 3)
 |     0, 0, 0, 0, 0, 0, 0, 0, 0  % from 8
|];

% Flow variables on each directed arc.
array[N, N] of var 0..max(c): f;

% Capacity constraints and no self-flow
constraint forall(i,j in N)(
  (i = j -> f[i,j] = 0) /\
  f[i,j] <= c[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in N where v != s /\ v != t)(
  sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
);

% Objective: maximize total flow into sink (equivalently, out of source)
var 0..sum(j in N)(c[s,j]): maxFlow = sum(i in N)(f[i,t]);

solve maximize maxFlow;

output [
  "Maximum flow (Tbps) = ", show(maxFlow), "\n",
  "Flow matrix f[i,j]:\n", show(f), "\n"
];