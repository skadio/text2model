% Shortest path from S to T in an undirected weighted graph (embedded data)

include "globals.mzn";

% Node indexing:
% 1 = S, 2..7 = nodes 2..7, 8 = T
int: N = 8;
int: S = 1;
int: T = 8;

set of int: V = 1..N;

% Edges (undirected) represented as directed arcs both ways
int: M = 18;
array[1..M] of int: u = [
  1,2,  1,3,
  2,4,  2,3,
  3,5,  3,6,
  4,6,
  6,7,
  5,8,
  7,8
];
array[1..M] of int: v = [
  2,1,  3,1,
  4,2,  3,2,
  5,3,  6,3,
  6,4,
  7,6,
  8,5,
  8,7
];
array[1..M] of int: w = [
  5,5,  4,4,
  3,3,  2,2,
  1,1,  7,7,
  2,2,
  3,3,
  5,5,
  1,1
];

% Binary decision: whether arc e is used in the path
array[1..M] of var 0..1: x;

% Flow conservation for a single unit of flow from S to T
constraint
  forall(n in V) (
    sum(e in 1..M where u[e] = n)(x[e]) - sum(e in 1..M where v[e] = n)(x[e]) =
      (if n = S then 1 else if n = T then -1 else 0 endif endif)
  );

% Objective: minimize total distance
var int: dist = sum(e in 1..M)(w[e] * x[e]);
solve minimize dist;

output [
  "Shortest distance S->T (m): ", show(dist), "\n"
];