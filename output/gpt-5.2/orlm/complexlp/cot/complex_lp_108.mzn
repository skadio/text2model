% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
  [| 0,  9,  6,  1,  8, 14,  1, 17 |
   | 1,  0,  6, 14, 16,  8, 19, 15 |
   | 4,  7,  0,  9,  1,  2,  9,  4 |
   |11,  5, 14,  0, 17,  6, 20, 13 |
   | 8,  5, 20,  0,  0, 16,  5,  5 |
   |15, 18,  9,  1, 19,  0, 16,  0 |
   |20, 15,  1,  0, 11,  6,  0, 19 |
   | 4, 18, 10,  2,  1, 20, 14,  0 |];

int: U = sum(j in V)(cap[s,j]); % upper bound on max flow (total out of source)

% Variables
array[V, V] of var 0..U: f;
var 0..U: F;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective flow value
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;

output ["Maximum flow (MW) = ", show(F), "\n"];