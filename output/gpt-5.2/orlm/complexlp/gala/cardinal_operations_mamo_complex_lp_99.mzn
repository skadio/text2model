include "globals.mzn";

% Max flow from source s=0 to sink t=5 on a directed network with capacities.
int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

% Capacity matrix cap[i,j] (0 means no arc)
array[N, N] of int: cap =
[|  0,14, 9, 8, 7, 8
 |  4, 0, 9,10, 0,12
 |  4,12, 0,13,20,16
 | 10, 8,12, 0, 0,18
 |  3,13,11,20, 0, 2
 | 17, 4, 8, 2,12, 0 |];

int: maxCap = max([cap[i,j] | i in N, j in N]);

% Flow variables on all ordered pairs (i,j); forced to 0 if cap=0 or i=j.
array[N, N] of var 0..maxCap: f;

constraint forall(i in N, j in N) (
  if i = j \/ cap[i,j] = 0 then
    f[i,j] = 0
  else
    f[i,j] <= cap[i,j]
  endif
);

% Flow conservation at intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Value of flow = net outflow from source (equivalently net inflow to sink)
var 0..sum(j in N)(cap[s,j]): F;
constraint F = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

solve maximize F;

output [
  "MaxFlow = ", show(F), " GB/s\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j=0 then "" else " " endif ++ show(f[i,j]) | j in N]) ++ "\n" | i in N ])
];