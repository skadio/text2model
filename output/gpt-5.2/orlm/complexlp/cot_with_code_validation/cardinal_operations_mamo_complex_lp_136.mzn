% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
 % to:  0,  1,  2,  3,  4,  5,  6
        0, 15,  2, 16,  3,  5,  3,   % from 0
        7,  0,  0,  0, 19, 15, 16,   % from 1
       11, 14,  0, 14,  8, 11,  6,   % from 2
       17, 11, 11,  0, 11, 16, 19,   % from 3
       10,  4, 17, 20,  0, 12, 17,   % from 4
        3,  0,  4,  5, 20,  0,  4,   % from 5
       15,  2, 15, 18, 17,  7,  0    % from 6
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V) (
    f[i,i] = 0
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