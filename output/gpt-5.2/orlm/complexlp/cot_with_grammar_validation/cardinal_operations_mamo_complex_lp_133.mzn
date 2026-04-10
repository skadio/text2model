% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
% to:  0  1  2  3  4  5  6  7  8
        0, 6,20,15, 9,20,17,16,20,  % from 0
        0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 1 (not fully specified in prompt)
        0, 0, 0, 0,19, 0, 0, 0, 0,  % from 2 (only 2->4 specified)
        0, 0, 0, 0, 0, 0, 0, 0,20,  % from 3 (only 3->8 specified)
        0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 4
        0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 5
        0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 6
        0, 0, 0,20, 0, 0, 0, 0, 0,  % from 7 (only 7->3 specified)
        0, 0, 0, 0, 0, 0, 0, 0, 0   % from 8
]);

int: U = max([cap[i,j] | i in V, j in V]); % upper bound for any arc flow

% Variables
array[V, V] of var 0..U: f;     % flow on each directed arc
var 0..(N*U): F;                % total s->t flow (bounded safely)

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;