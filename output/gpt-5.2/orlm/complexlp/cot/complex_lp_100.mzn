% Parameters (with values embedded)
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  % to:   0  1  2  3  4  5  6  7  8
          0,15, 1, 9,18,12,18, 6,17,  % from 0
         14, 0,13,11,14,10,15, 4,15,  % from 1
          3, 0, 0, 2,14,16, 7,12, 4,  % from 2
          5,20, 0, 0, 9, 1,12, 1,20,  % from 3
         11,18,12, 3, 0, 4,16,15, 2,  % from 4
         13, 8, 8, 6, 4, 0, 8,10,11,  % from 5
         12, 1, 3, 4,11, 8, 0,10,19,  % from 6
         18, 3, 9, 5, 9,17,10, 0,13,  % from 7
          9, 8,12, 2, 5, 2,16, 5, 0   % from 8
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;     % flow on each directed arc
var 0..sum(j in V)(cap[s,j]): F; % total s->t flow value

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V) (
    f[i,i] = 0
  );

% Flow conservation at intermediate nodes; define F as net outflow of s and net inflow to t
constraint
  F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint
  forall(i in V where i != s /\ i != t) (
    sum(j in V)(f[i,j]) - sum(j in V)(f[j,i]) = 0
  );

constraint
  F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;