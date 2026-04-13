include "globals.mzn";

% Max-flow from source s=0 to sink t=5 on a directed network with capacities.
int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

% Capacity matrix cap[i,j] = max flow allowed from i to j (0 means no arc)
array[N, N] of int: cap =
  [|  0, 17, 14, 13, 11,  3
   |  1,  0, 18, 14, 12, 16
   |  5,  1,  0,  7,  2,  5
   | 10, 13, 19,  0,  4, 16
   |  3,  0, 13,  0,  0, 14
   | 15, 16,  4,  1, 16,  0 |];

% Decision variables: flow on each directed arc
int: U = max([cap[i,j] | i in N, j in N]); % upper bound for any single arc flow
array[N, N] of var 0..U: f;

% Respect capacities (and force 0 flow where no arc)
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes (excluding source and sink)
constraint forall(v in N where v != s /\ v != t) (
  sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
);

% Objective: maximize total flow leaving source (equivalently entering sink)
var 0..sum(j in N)(cap[s,j]): maxFlow = sum(j in N)(f[s,j]);
constraint maxFlow = sum(i in N)(f[i,t]); % consistency with sink inflow

solve maximize maxFlow;

output [
  "Maximum trains per day from City ", show(s), " to City ", show(t), " = ", show(maxFlow), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j==0 then "" else " " endif ++ show(f[i,j]) | j in N ]) ++ "\n" | i in N ])
];