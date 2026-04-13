% Max flow on a directed graph (Sector 0 -> Sector 8)
% Data embedded (no .dzn required)

include "globals.mzn";

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
  0,  7,  4, 17,  4, 18, 17,  5, 14,
  2,  0, 11, 10,  1, 19,  6, 16, 13,
  8, 15,  0,  5,  1,  5, 11, 17, 18,
  2,  5,  0,  0,  6, 17,  1, 16, 14,
 15,  6, 20, 15,  0,  7, 13,  6, 19,
 15,  2,  8,  2,  3,  0,  2,  9,  2,
 10, 12, 11, 10, 19,  9,  0, 17,  1,
  0, 20, 15, 19, 20, 18, 14,  0,  8,
 16, 13,  3,  3, 20, 19,  2,  7,  0
]);

% Only create decision variables on existing arcs to speed up solving
set of (int,int): A = { (i,j) | i in V, j in V where i != j /\ cap[i,j] > 0 };

array[V, V] of var int: f =
  array2d(V, V, [ if (i,j) in A then var 0..cap[i,j] else 0 endif
                  | i in V, j in V ]);

var int: maxflow;

% Flow conservation
constraint forall(v in V where v != s /\ v != t)(
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define maxflow by net outflow from source (equivalently, net inflow to sink)
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];