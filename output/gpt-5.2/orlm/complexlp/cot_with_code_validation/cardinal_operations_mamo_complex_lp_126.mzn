% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
% to: 0  1  2  3  4  5  6  7
      0,19, 5, 7, 0,17,19, 9,   % from 0
      6, 0,15,15,16, 8, 5, 0,   % from 1
      5, 6, 0, 3,10, 7, 6, 3,   % from 2
      8, 2, 6, 0, 5,17, 0, 1,   % from 3
     17, 4,10,10, 0, 6,15,14,   % from 4
     11,11, 9, 7, 7, 0,16,19,   % from 5
     13,19,14,14,16, 1, 0,16,   % from 6
      0,14, 0,17, 1, 7, 9, 0    % from 7
]);

% Variables
array[V, V] of var 0..19: f;  % 19 is the maximum capacity in this instance
var 0..200: maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;