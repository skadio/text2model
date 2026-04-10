% Parameters (with values embedded)
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
  % to: 0  1  2  3  4  5  6  7   (from row index)
     0, 5,16,11, 2,10,17, 2,   % 0
     8, 0,14,14, 2, 7,11, 1,   % 1
    17,20, 0,16,13, 0, 6, 1,   % 2
     3,16,10, 0,19,12, 3,15,   % 3
    15,12,19,18, 0,14,12,15,   % 4
     2,20,20,17, 4, 0,10,17,   % 5
    15,13,13, 5,10,15, 0,19,   % 6
    10, 3,14,11, 5,20, 4, 0    % 7
]);

% Variables
int: maxCap = max([cap[i,j] | i in V, j in V]);
int: UB = (N-1) * maxCap; % safe upper bound for total flow value

array[V, V] of var 0..maxCap: f;   % flow on each directed arc
var 0..UB: F;                      % total s->t flow value

% Constraints
% Capacity / no-arc enforcement
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% No self-flow (optional clarity)
constraint forall(i in V)( f[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

% Define objective flow value via net outflow from source and net inflow to sink
constraint
  F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;