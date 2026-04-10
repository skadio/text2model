% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;
array[1..num_edges] of int: a;
int: s;
int: t;

% Variables
array[1..num_edges] of var 0..max(a): f;
var 0..sum(a): total_flow;

% Constraints
constraint forall(e in 1..num_edges) ( f[e] <= a[e] );

constraint total_flow =
  sum(e in 1..num_edges where E[e,1] = s)(f[e]) -
  sum(e in 1..num_edges where E[e,2] = s)(f[e]);

constraint forall(v in 1..n where v != s /\ v != t)(
  sum(e in 1..num_edges where E[e,2] = v)(f[e]) =
  sum(e in 1..num_edges where E[e,1] = v)(f[e])
);

% Objective
solve maximize total_flow;