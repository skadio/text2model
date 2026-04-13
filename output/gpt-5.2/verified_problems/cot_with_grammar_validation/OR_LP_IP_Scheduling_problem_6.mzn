% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;
array[1..num_edges] of int: a;
int: s;
int: t;

set of int: N = 1..n;
set of int: A = 1..num_edges;

array[A] of int: tail = [ E[e,1] | e in A ];
array[A] of int: head = [ E[e,2] | e in A ];

% Variables
array[A] of var 0..max(a): f;
var 0..sum(a): F;

% Constraints
constraint forall(e in A) (
  f[e] <= a[e]
);

constraint forall(v in N where v != s /\ v != t) (
  sum(e in A where head[e] = v)(f[e]) = sum(e in A where tail[e] = v)(f[e])
);

constraint F = sum(e in A where tail[e] = s)(f[e]) - sum(e in A where head[e] = s)(f[e]);

constraint F = sum(e in A where head[e] = t)(f[e]) - sum(e in A where tail[e] = t)(f[e]);

% Objective
solve maximize F;