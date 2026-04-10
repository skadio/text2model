% Parameters (with values embedded)
include "globals.mzn";

int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V,
[
  % to:   0   1   2   3   4   5
         0,  4, 12, 19, 13, 11,   % from 0
        20,  0, 13,  9, 10,  0,   % from 1
        14,  8,  0,  5, 13, 11,   % from 2
         5, 15, 18,  0,  6,  7,   % from 3
         8, 17, 20, 14,  0,  9,   % from 4
         9, 19, 19, 11,  4,  0    % from 5
]);

int: U = max([cap[i,j] | i in V, j in V]); % upper bound on any single arc capacity

% Variables
array[V, V] of var 0..U: f;          % flow on directed arc (i,j)
var 0..sum(j in V)(cap[s,j]): F;      % total flow value from source

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define total flow value from source and into sink
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;