% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  % to: 0  1  2  3  4  5  6  7  8   <- from row
     0,  5,  2,  7, 17,  4,  1,  2, 13,  % from 0
    12,  0, 15, 18,  8,  9,  8,  1, 15,  % from 1
    17, 16,  0, 20, 17, 13,  2, 19,  6,  % from 2
     5,  9, 14,  0, 10, 18, 20,  9, 18,  % from 3
    12, 14,  7,  6,  0,  6, 17,  4,  9,  % from 4
    12, 11, 10,  1, 13,  0, 14, 12, 14,  % from 5
    13,  7,  3,  9,  1, 14,  0,  7, 16,  % from 6
    18, 15,  8,  0, 12, 13,  5,  0, 17,  % from 7
     3, 11, 15, 14,  0,  4, 18, 16,  0   % from 8
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: UB = (N-1) * maxCap; % safe upper bound on total flow value

% Variables
array[V, V] of var 0..maxCap: f;   % flow on arc i->j
var 0..UB: F;                      % total s->t flow value

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% No self-flow (not needed, but keeps things clean)
constraint
  forall(i in V) (
    f[i,i] = 0
  );

% Flow conservation at intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

% Define flow value at source and sink
constraint
  F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint
  F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;

% Optional output
output [
  "Max flow (thousand gallons/hour) = ", show(F), "\n"
];