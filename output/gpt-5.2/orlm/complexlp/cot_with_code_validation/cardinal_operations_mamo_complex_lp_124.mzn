% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
%      0  1  2  3  4  5  6  7  8
array2d(V, V, [
        0, 1,16, 8,18, 4, 0, 8, 5,  % from 0
       15, 0,11, 8,13, 2, 1, 7, 6,  % from 1
       15, 4, 0, 3, 1,13,13,11, 9,  % from 2
        4,16, 8, 0,12,18,19, 8,11,  % from 3
        4,19, 3, 2, 0, 6, 1,13,14,  % from 4
        6,19,15,10,16, 0,17,15,17,  % from 5
       13, 7,13, 4,14, 3, 0, 8, 8,  % from 6
       10, 6,19, 1,12, 6, 9, 0,14,  % from 7
        0, 0, 0, 0, 0, 0, 0, 0, 0   % from 8 (not needed as source)
]);

int: max_cap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..max_cap: f;
var 0..sum([cap[s,j] | j in V]): total_flow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V where i != s /\ i != t) (
    sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
  );

constraint
  total_flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint
  total_flow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;