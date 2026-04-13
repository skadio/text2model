% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0
  0,14,20,7,9,1,4,8,19,
  % from 1
  3,0,15,12,17,0,15,3,3,
  % from 2
  11,8,0,1,19,16,5,1,2,
  % from 3
  13,13,2,0,16,20,16,17,3,
  % from 4
  6,15,7,3,0,18,1,3,9,
  % from 5
  15,20,8,4,6,0,3,1,4,
  % from 6
  5,15,19,4,15,12,0,3,8,
  % from 7
  7,14,13,12,9,10,3,0,4,
  % from 8
  3,12,6,6,1,11,6,1,0
]);

int: U = max([cap[i,j] | i in V, j in V]); % upper bound for any arc flow

% Variables
array[V, V] of var 0..U: f;
var 0..(sum(j in V where j != s)(cap[s,j])): maxflow;

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
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;