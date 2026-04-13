% Parameters
int: N = 8;                 % 1=S, 8=T, nodes 2..7 are intermediate
int: S = 1;
int: T = 8;
set of int: V = 1..N;

array[V, V] of int: w =
array2d(V, V,
[
  % to:  1  2  3  4  5  6  7  8
        0, 5, 4, 0, 0, 0, 0, 0,   % from 1 (S)
        5, 0, 2, 3, 0, 0, 0, 0,   % from 2
        4, 2, 0, 0, 1, 7, 0, 0,   % from 3
        0, 3, 0, 0, 0, 2, 0, 0,   % from 4
        0, 0, 1, 0, 0, 0, 0, 5,   % from 5
        0, 0, 7, 2, 0, 0, 3, 0,   % from 6
        0, 0, 0, 0, 0, 3, 0, 1,   % from 7
        0, 0, 0, 0, 5, 0, 1, 0    % from 8 (T)
]);

% A safe upper bound on shortest path length
int: UB = sum(i,j in V where w[i,j] > 0)(w[i,j]);

% Variables
array[V] of var 0..UB: d;

% Constraints
constraint d[S] = 0;

% Bellman-Ford style relaxation to enforce shortest-path distances
constraint
  forall(k in 1..N-1)(
    forall(i,j in V where w[i,j] > 0)(
      d[j] <= d[i] + w[i,j]
    )
  );

% Objective
solve minimize d[T];

% (Optional) output as nearest meter (already integer distances here)
output [ "Shortest distance S->T (m) = ", show(d[T]), "\n" ];