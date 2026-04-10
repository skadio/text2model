% Max flow from source (0) to sink (8) with given capacities.
% Units: thousand gallons per hour.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[
| 0,  9,  7, 18,  0,  0,  7,  0,  2 |
|15,  0, 11,  5, 20, 15, 18,  9, 15 |
| 3,  8,  0, 10, 16, 18,  8,  0, 20 |
|13,  3,  7,  0, 20, 13, 16,  6, 20 |
| 7, 20,  2,  4,  0,  9,  3, 14,  2 |
|17, 10,  5,  1,  4,  0,  4,  3, 20 |
| 0, 20, 10, 10, 15,  5,  0,  1, 10 |
|10,  3,  9,  4,  3, 13, 18,  0, 20 |
| 2, 12, 10,  5, 15, 14,  0, 10,  0 |
];

int: UB = sum(i in V)(cap[s,i]); % trivial upper bound on max flow

array[V, V] of var 0..UB: f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i,j in V)( f[i,j] <= cap[i,j] );

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

% Objective: maximize total flow out of source (equals into sink by conservation)
var 0..UB: maxflow = sum(j in V)(f[s,j]);

solve maximize maxflow;

output [
  "Maximum flow (thousand gallons per hour) = ", show(maxflow), "\n"
];