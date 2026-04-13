% Parameters
int: N = 4;
set of int: V = 1..N;

int: M = 5;
set of int: E = 1..M;

array[E] of int: from = [1, 1, 2, 2, 3];
array[E] of int: to   = [2, 3, 3, 4, 4];
array[E] of int: cap  = [8, 7, 2, 4, 12];

int: s = 1;
int: t = 4;

int: U = sum(e in E)(cap[e]);

% Variables
array[E] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(e in E)(f[e] <= cap[e]);

constraint forall(v in V where v != s /\ v != t)(
  sum(e in E where to[e] == v)(f[e]) = sum(e in E where from[e] == v)(f[e])
);

constraint maxflow = sum(e in E where from[e] == s)(f[e]) - sum(e in E where to[e] == s)(f[e]);

% Objective
solve maximize maxflow;