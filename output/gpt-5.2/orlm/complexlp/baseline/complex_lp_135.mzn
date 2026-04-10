% Maximum flow from City 0 (source) to City 7 (sink) with given capacities.
% Units: thousands of vehicles per hour.

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  % to:  0   1   2   3   4   5   6   7   (from row)
        0, 18,  5,  6,  8, 10, 16,  0,  % 0
       18,  0,  1, 15, 20, 13,  1,  2,  % 1
       18, 16,  0, 19, 15,  4,  9, 10,  % 2
       20,  2, 18,  0, 19, 17, 15, 19,  % 3
       14, 13, 14,  1,  0,  8, 16, 20,  % 4
        0, 17, 18, 10, 17,  0, 16,  6,  % 5
        5, 14, 19,  6,  0, 19,  0, 12,  % 6
        7, 16, 17, 13,  6,  9,  5,  0   % 7
]);

% Flow variables on each directed arc
array[V, V] of var 0..20000: f;

% Respect capacities (and force f=0 when cap=0)
constraint forall(i in V, j in V)(
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Objective: maximize net flow out of source (equivalently into sink)
var int: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (thousands of vehicles per hour) = ", show(maxflow), "\n"
];