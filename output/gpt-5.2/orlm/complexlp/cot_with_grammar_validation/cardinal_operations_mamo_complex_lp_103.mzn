% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  0, 11,  1,  6,  4,  5,  7,  1,
  3,  0, 15, 15, 16,  9, 14, 12,
 19,  9,  0,  5,  9, 11, 16,  3,
 15,  1, 14,  0,  0,  4,  1, 15,
  8, 16,  7,  3,  0, 16, 10, 11,
  7,  8,  1, 11, 19,  0,  3,  3,
  2, 19,  2,  6, 12, 20,  0,  6,
 15, 17,  4,  7,  8,  2, 16,  0
]);

int: U = max([cap[i,j] | i in V, j in V]); % upper bound for any arc flow

% Variables
array[V, V] of var 0..U: f;     % flow on each directed arc
var 0..(N*U): total_flow;        % value of s-t flow

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

constraint
  total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;