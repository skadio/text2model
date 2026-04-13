% Parameters
int: N = 4;
set of int: V = 1..N;

int: S = 1;
int: T = 4;

set of int: A = 1..5;

array[A] of int: u = [1, 1, 2, 2, 3];
array[A] of int: v = [2, 3, 3, 4, 4];
array[A] of int: cap = [8, 7, 2, 4, 12];

int: maxCapSum = sum(a in A)(cap[a]);

% Variables
array[A] of var 0..maxCapSum: f;

% Constraints
constraint forall(a in A)(f[a] <= cap[a]);

constraint forall(i in V where i != S /\ i != T)(
  sum(a in A where v[a] == i)(f[a]) = sum(a in A where u[a] == i)(f[a])
);

% Objective
var 0..maxCapSum: maxflow = sum(a in A where u[a] == S)(f[a]);
solve maximize maxflow;