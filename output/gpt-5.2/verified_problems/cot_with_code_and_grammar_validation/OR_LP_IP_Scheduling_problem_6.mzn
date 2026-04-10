% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;
array[1..num_edges] of int: a;
int: s;
int: t;

set of int: N = 1..n;
set of int: A = 1..num_edges;

% Variables
array[A] of var 0..max(a): f;

% Constraints
constraint
  forall(e in A) (
    f[e] <= a[e]
  );

constraint
  forall(v in N where v != s /\ v != t) (
    sum(e in A where E[e,2] = v)(f[e]) = sum(e in A where E[e,1] = v)(f[e])
  );

% Objective
var 0..sum(a): total_flow =
  sum(e in A where E[e,1] = s)(f[e]) - sum(e in A where E[e,2] = s)(f[e]);

solve maximize total_flow;