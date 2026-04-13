% Parameters (with values embedded)
int: N = 4;
set of int: V = 1..N;

int: M = 5;
set of int: E = 1..M;

array[E] of int: from = [1, 1, 2, 2, 3];
array[E] of int: to   = [2, 3, 3, 4, 4];
array[E] of int: cap  = [8, 7, 2, 4, 12];

int: s = 1;
int: t = 4;

% Variables
array[E] of var 0..max(cap): f;
var 0..sum(cap): F;

% Constraints
constraint
  forall(e in E) (
    f[e] <= cap[e]
  );

% Flow conservation at intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(e in E where to[e] = v)(f[e]) = sum(e in E where from[e] = v)(f[e])
  );

% Define total flow out of source and into sink (they are equal given conservation)
constraint
  F = sum(e in E where from[e] = s)(f[e]);

constraint
  F = sum(e in E where to[e] = t)(f[e]);

% Objective
solve maximize F;

output [
  "Maximum flow (rounded to nearest integer): ", show(F), "\n",
  "Edge flows:\n"
] ++
[
  "  " ++ show(from[e]) ++ " -> " ++ show(to[e]) ++ " : " ++ show(f[e]) ++ " / " ++ show(cap[e]) ++ "\n"
  | e in E
];