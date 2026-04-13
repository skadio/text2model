% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
% rows: from i, cols: to j
[|  0,  6,  1, 14, 20,  6, 13, 13, 15
 |  2,  0,  5,  5, 13,  5, 12,  9, 15
 | 15,  0,  0,  8, 16,  9, 19, 15,  6
 | 13,  8,  0,  0, 14, 12,  9,  1,  2
 |  4, 14, 19, 16,  0, 14, 11, 11,  2
 | 19, 18,  5, 20,  9,  0, 11,  5,  7
 | 11, 14, 20, 17, 11, 13,  0, 11, 16
 |  6,  2, 17,  0, 10, 13, 17,  0,  9
 |  8,  9,  7, 18, 12, 13,  5,  9,  0 |];

int: U = max([cap[i,j] | i in V, j in V]); % upper bound on any arc flow (<=20)

% Variables
array[V, V] of var 0..U: f;          % flow on each directed arc
array[V] of var 0..(N*U): outflow;    % total outflow per node
array[V] of var 0..(N*U): inflow;     % total inflow per node
var 0..(N*U): F;                      % total s->t flow value

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V) (
  outflow[i] = sum(j in V)(f[i,j])
);

constraint forall(i in V) (
  inflow[i] = sum(j in V)(f[j,i])
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  outflow[v] = inflow[v]
);

% Define total flow value
constraint F = outflow[s] - inflow[s];
constraint F = inflow[t] - outflow[t];

% Objective
solve maximize F;

output [
  "Maximum transferable water (million gallons/day) = ", show(F), "\n"
];