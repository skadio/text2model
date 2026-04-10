% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
[|  0, 19,  4,  1,  9, 13,  8, 20
 | 10,  0, 12, 12,  8, 12,  7,  7
 | 13, 11,  0,  8,  4,  1,  2,  3
 |  4, 12, 13,  0, 18,  6, 19,  8
 |  9, 16,  2,  0,  0, 14, 18,  7
 | 10, 11,  7, 11, 16,  0, 16,  5
 | 14, 11,  9, 11,  3, 17,  0, 19
 | 12, 20,  5, 11, 10,  4,  6,  0 |];

int: U = max([cap[i,j] | i in V, j in V]); % upper bound for a single arc

% Variables
array[V, V] of var 0..U: f;         % flow on each directed arc
var 0..(sum(j in V)(cap[s,j])): F;   % total flow value (bounded by total out capacity of source)

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation for all intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

% Define objective flow value as net outflow from source (also equals net inflow to sink)
constraint
  F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Objective
solve maximize F;