% Parameters
int: N = 8;
int: S = 1;
int: T = 8;

set of int: V = 1..N;

int: E = 18;
set of int: A = 1..E;

array[A] of int: u = [ 1,1, 2,2,2, 3,3,3,3, 4,4, 5,5, 6,6,6, 7,7 ];
array[A] of int: v = [ 2,3, 1,4,3, 1,2,5,6, 2,6, 3,8, 3,4,7, 6,8 ];
array[A] of int: w = [ 4,5, 5,3,2, 4,2,1,7, 3,2, 1,5, 7,2,3, 3,1 ];

int: Wsum = sum(a in A)(w[a]);

% Variables
array[V] of var 0..Wsum: dist;

% Constraints
constraint dist[S] = 0;

constraint forall(a in A) (
  dist[v[a]] <= dist[u[a]] + w[a]
);

% Objective
solve minimize dist[T];