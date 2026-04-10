include "globals.mzn";

% Max-flow from source s=0 to sink t=6 on a directed graph with capacities.
int: n = 7;
set of int: N = 0..n-1;

int: s = 0;
int: t = 6;

% Capacity matrix c[u,v] (MW). 0 means no arc.
array[N, N] of int: cap =
array2d(N, N,
[
  % v: 0  1  2  3  4  5  6
      0,16, 6,16, 2,17,15,   % u=0
      7, 0,13, 3, 0, 8,17,   % u=1
      3,17, 0,18,11,18,11,   % u=2
      9, 0,15, 0, 3, 8,10,   % u=3
      3, 6, 1,16, 0,13,10,   % u=4
     15,20, 2, 6,18, 0, 9,   % u=5
      4, 6, 8,13,16,10, 0    % u=6
]);

% Decision variables: flow on each directed arc (including those with cap=0 -> forced to 0)
array[N, N] of var 0..max(cap): f;

% Capacity constraints (also forces f[u,v]=0 when cap[u,v]=0)
constraint forall(u in N, v in N) (
  f[u,v] <= cap[u,v]
);

% No self-loop flow
constraint forall(i in N)( f[i,i] = 0 );

% Flow conservation for intermediate nodes
constraint forall(k in N where k != s /\ k != t)(
  sum(u in N)(f[u,k]) = sum(v in N)(f[k,v])
);

% Value of flow: total out of source equals total into sink
var 0..sum(v in N)(cap[s,v]): F;
constraint F = sum(v in N)(f[s,v]) - sum(u in N)(f[u,s]);
constraint F = sum(u in N)(f[u,t]) - sum(v in N)(f[t,v]);

solve maximize F;

output [
  "Max flow (MW) = ", show(F), "\n",
  "Flow matrix f[u,v] (u rows, v cols):\n",
  show(f), "\n"
];