include "globals.mzn";

% Max flow from source s=0 to sink t=6 in a directed network with capacities.
int: n = 7;
set of int: V = 0..n-1;
int: s = 0;
int: t = 6;

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
array2d(V, V, [
  % to:   0  1  2  3  4  5  6     from:
          0,17, 3,20,11,11, 3,    % 0
         11, 0,12,18, 5, 6, 4,    % 1
          7, 2, 0,15,13,20,18,    % 2
          7, 4, 2, 0, 2,15, 3,    % 3
         19,12,16, 4, 0,19, 4,    % 4
         13,20,10,14,15, 0, 1,    % 5
          3, 3, 6,20, 9,10, 0     % 6
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Flow variables on each directed arc (i->j)
array[V, V] of var 0..maxCap: f;

% Respect capacities (and force 0 flow where no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize total flow out of source (equals into sink by conservation)
var 0..(n*maxCap): total_flow;
constraint total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize total_flow;

output [
  "Maximum flow (TB per hour) = ", show(total_flow), "\n",
  "Flow matrix f[from,to]:\n", show(f), "\n"
];