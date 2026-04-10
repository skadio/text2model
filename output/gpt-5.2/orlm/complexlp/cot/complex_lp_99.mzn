% Parameters (with values embedded)
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
%      0  1  2  3  4  5
array2d(V, V, [
        0,14, 9, 8, 7, 8,   % from 0
        4, 0, 9,10, 0,12,   % from 1
        4,12, 0,13,20,16,   % from 2
       10, 8,12, 0, 0,18,   % from 3
        3,13,11,20, 0, 2,   % from 4
       17, 4, 8, 2,12, 0    % from 5
]);

% Upper bound on total flow value (safe bound)
int: UB = sum(j in V)(cap[s,j]);

% Variables
array[V, V] of var 0..UB: f;     % flow on arc (i,j)
var 0..UB: F;                    % total flow from s to t

% Constraints
% Capacity constraints (also enforce no-arc when cap=0)
constraint forall(i in V, j in V)(
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define flow value as net outflow from source and net inflow to sink
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;

output ["Maximum flow (GB/s) = \(F)\n"];