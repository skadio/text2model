% Shortest path from S to T with embedded data.
% Nodes: 1=S, 2..7 as given, 8=T

include "globals.mzn";

int: n = 8;
int: S = 1;
int: T = 8;

set of int: N = 1..n;

% Directed edges (as described; both directions included when given)
int: m = 20;
array[1..m] of int: from = [
  1,1,        % S->2, S->3
  2,2,2,      % 2->S, 2->4, 2->3
  3,3,3,3,    % 3->S, 3->2, 3->5, 3->6
  4,4,        % 4->2, 4->6
  5,5,        % 5->3, 5->T
  6,6,6,      % 6->3, 6->4, 6->7
  7,7,        % 7->6, 7->T
  8,8         % T->5, T->7
];

array[1..m] of int: to = [
  2,3,
  1,4,3,
  1,2,5,6,
  2,6,
  3,8,
  3,4,7,
  6,8,
  5,7
];

array[1..m] of int: w = [
  4,5,
  5,3,2,
  4,2,1,7,
  3,2,
  1,5,
  7,2,3,
  3,1,
  5,1
];

% Decision: whether an arc is used in the S->T path
array[1..m] of var 0..1: x;

% Flow conservation for a single path from S to T
constraint
  forall(v in N) (
    sum(e in 1..m where from[e] == v)(x[e]) - sum(e in 1..m where to[e] == v)(x[e]) =
      if v == S then 1 else if v == T then -1 else 0 endif endif
  );

var int: dist = sum(e in 1..m)(x[e] * w[e]);

solve minimize dist;

output [
  "Shortest distance S->T (meters, rounded): ", show(dist), "\n"
];