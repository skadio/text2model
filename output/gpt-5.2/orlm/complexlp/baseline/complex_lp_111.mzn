% Max flow from source 0 to sink 7 on a directed graph with given capacities.

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  % to:  0,  1,  2,  3,  4,  5,  6,  7
         0, 19,  4,  1,  9, 13,  8, 20,  % from 0
        10,  0, 12, 12,  8, 12,  7,  7,  % from 1
        13, 11,  0,  8,  4,  1,  2,  3,  % from 2
         4, 12, 13,  0, 18,  6, 19,  8,  % from 3
         9, 16,  2,  0,  0, 14, 18,  7,  % from 4 (no link to 3,4)
        10, 11,  7, 11, 16,  0, 16,  5,  % from 5
        14, 11,  9, 11,  3, 17,  0, 19,  % from 6
        12, 20,  5, 11, 10,  4,  6,  0   % from 7
]);

int: U = sum(j in V)(cap[s,j]); % safe upper bound on max flow

array[V, V] of var 0..U: f;

% Capacity constraints
constraint forall(i,j in V) ( f[i,j] <= cap[i,j] );

% Flow conservation (except source and sink)
constraint forall(k in V where k != s /\ k != t)(
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

var 0..U: F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Equivalent definition at sink (redundant but helpful)
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [
  "Maximum flow (MW) from ", show(s), " to ", show(t), ": ", show(F), "\n"
];