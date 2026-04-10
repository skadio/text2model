% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  4, 12, 19, 13, 11,
 20,  0, 13,  9, 10,  0,
 14,  8,  0,  5, 13, 11,
  5, 15, 18,  0,  6,  7,
  8, 17, 20, 14,  0,  9,
  9, 19, 19, 11,  4,  0
]);

int: totalCapOutS = sum(j in V)(cap[s,j]);

% Variables
array[V, V] of var 0..totalCapOutS: f;
var 0..totalCapOutS: maxflow;

% Constraints
constraint
  forall(i in V, j in V)(
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V)(
    sum(j in V where j != i)(f[i,j]) - sum(j in V where j != i)(f[j,i]) =
      if i == s then maxflow
      elseif i == t then -maxflow
      else 0 endif
  );

% Objective
solve maximize maxflow;