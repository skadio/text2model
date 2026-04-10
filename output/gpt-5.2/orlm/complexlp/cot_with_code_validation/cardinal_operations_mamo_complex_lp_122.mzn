% Max flow from source s to sink t in a directed capacitated network

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = array2d(V, V,
[
  0, 15, 19,  4,  4,  3, 20, 17,
  8,  0,  6,  5, 20,  3, 15,  1,
 11, 13,  0, 16, 15,  7, 10, 13,
 17, 20,  6,  0, 11,  3,  2,  0,
 10, 15,  5,  0,  0,  9,  9, 15,
  9, 17,  5,  1,  9,  0, 20,  2,
  4, 16, 10,  2,  1,  6,  0,  4,
  0,  0,  0,  0,  0,  0,  0,  0
]);

set of (int,int): A = {(i,j) | i in V, j in V where cap[i,j] > 0};

% Upper bound on total flow
int: UB = sum(j in V where cap[s,j] > 0)(cap[s,j]);

% Variables: only for existing arcs (reduces search, avoids timeout)
array[A] of var 0..max([cap[i,j] | (i,j) in A]): f;
var 0..UB: total_flow;

% Capacity constraints
constraint forall((i,j) in A) (f[(i,j)] <= cap[i,j]);

% Flow conservation for intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum((v,j) in A)(f[(v,j)]) = sum((i,v) in A)(f[(i,v)])
  );

% Total flow equals net outflow from source
constraint
  total_flow = sum((s,j) in A)(f[(s,j)]) - sum((i,s) in A)(f[(i,s)]);

solve :: int_search([f[a] | a in A], first_fail, indomain_max, complete)
maximize total_flow;

output [
  "total_flow=", show(total_flow), "\n"
];