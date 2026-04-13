% Parameters
int: N = 4;
set of int: V = 1..N;

int: A = 5;
set of int: E = 1..A;

array[E] of int: from = [1, 1, 2, 2, 3];
array[E] of int: to   = [2, 3, 3, 4, 4];
array[E] of int: cap  = [5, 7, 2, 4, 12];

int: s = 1;
int: t = 4;

int: cap_sum_out_s = sum(e in E where from[e] = s)(cap[e]);
int: cap_sum_in_t  = sum(e in E where to[e] = t)(cap[e]);
int: U = min(cap_sum_out_s, cap_sum_in_t);

% Variables
array[E] of var 0..U: f;
var 0..U: F;

% Constraints
constraint forall(e in E) (f[e] <= cap[e]);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(e in E where to[e] = v)(f[e]) = sum(e in E where from[e] = v)(f[e])
);

% Define total flow out of source and into sink
constraint F = sum(e in E where from[e] = s)(f[e]);
constraint F = sum(e in E where to[e] = t)(f[e]);

% Objective
solve maximize F;