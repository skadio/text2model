% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: S = 0;
int: T = 8;

array[V, V] of int: cap =
array2d(V, V,
[
% to:  0  1  2  3  4  5  6  7  8
      0,11,11,14, 6,11, 4,15, 9,  % from 0
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 1 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 2 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 3 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 4 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 5 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 6 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0,  % from 7 (unspecified -> 0)
      0, 0, 0, 0, 0, 0, 0, 0, 0   % from 8 (unspecified -> 0)
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(sum(j in V)(cap[S,j])): total_flow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != S /\ k != T) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

constraint
  total_flow = sum(j in V)(f[S,j]);

constraint
  total_flow = sum(i in V)(f[i,T]);

% Objective
solve maximize total_flow;