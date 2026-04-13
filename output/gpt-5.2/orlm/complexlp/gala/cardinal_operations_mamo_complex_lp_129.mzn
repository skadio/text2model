include "globals.mzn";

% Max flow from source s to sink t in a directed network with capacities.
int: n = 6;
set of int: N = 0..n-1;
int: s = 0;
int: t = 5;

% Capacities c[i,j] (0 means no arc).
array[N, N] of int: c =
array2d(N, N, [
  % j=0  1   2   3   4   5
     0, 11,  8, 11, 20, 16,   % i=0
    15,  0, 11, 16,  0, 20,   % i=1
     7,  4,  0,  4, 11,  0,   % i=2
     4,  8, 14,  0, 19,  0,   % i=3
    10,  0,  6, 19,  0, 13,   % i=4
    10, 15, 20, 19, 10,  0    % i=5
]);

int: U = sum(i in N, j in N)(c[i,j]); % safe upper bound on total flow

% Decision variables: flow on each arc
array[N, N] of var 0..U: f;

% Capacity constraints (also forces 0 flow on non-arcs)
constraint forall(i in N, j in N) (
  f[i,j] <= c[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(k in N where k != s /\ k != t) (
  sum(i in N)(f[i,k]) = sum(j in N)(f[k,j])
);

% Define total flow value: net outflow from source (equals net inflow to sink)
var 0..U: F;
constraint F = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);
constraint F = sum(i in N)(f[i,t]) - sum(j in N)(f[t,j]);

solve maximize F;

output [
  "Maximum flow (thousands of packets per unit time) = ", show(F), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j = 0 then "" else " " endif ++ show(f[i,j])
                    | j in N ]) ++ "\n"
          | i in N ])
];