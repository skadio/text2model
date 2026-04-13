include "globals.mzn";

% Nodes: 1=A, 2=B, 3=C, 4=D, 5=E
int: n = 5;
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

% Directed bandwidth matrix (0 = no direct link)
array[1..n, 1..n] of int: bw = array2d(1..n, 1..n, [
   0, 90, 85,  0, 65,
  95,  0, 70, 65, 34,
  60,  0,  0, 88, 80,
  67, 30, 25,  0, 84,
   0, 51,  0, 56,  0
]);

% We model a simple (loop-free) path from A to E that must pass through C.
% Use a permutation order[] over nodes; consecutive nodes in this order
% are the links used in the path, from position pA to pE.
array[1..n] of var 1..n: order;
constraint all_different(order);

% Position of each node in the permutation
array[1..n] of var 1..n: pos;
constraint inverse(order, pos);

% Must go from A to E (A before E) and pass through C in between
constraint pos[A] < pos[C] /\ pos[C] < pos[E];

% Ensure every consecutive link along the used segment exists (bw > 0)
constraint forall(k in 1..n-1)(
  (pos[A] <= k /\ k < pos[E]) -> bw[order[k], order[k+1]] > 0
);

% Bandwidth of the path = minimum bandwidth along used edges
array[1..n-1] of var 0..100: edge_bw;
constraint forall(k in 1..n-1)(
  edge_bw[k] = if pos[A] <= k /\ k < pos[E] then bw[order[k], order[k+1]] else 100 endif
);

var 0..100: path_bw;
constraint path_bw = min(edge_bw);

solve maximize path_bw;

output [
  "Order permutation (node indices 1=A..5=E): ", show(order), "\n",
  "Positions: A=", show(pos[A]), " C=", show(pos[C]), " E=", show(pos[E]), "\n",
  "Max path bandwidth (bottleneck): ", show(path_bw), "\n",
  "Used edges (from A to E):\n"
] ++
[
  if fix(pos[A]) <= k /\ k < fix(pos[E]) then
    "  " ++ show(order[k]) ++ " -> " ++ show(order[k+1]) ++
    "  bw=" ++ show(bw[fix(order[k]), fix(order[k+1])]) ++ "\n"
  else "" endif
  | k in 1..n-1
];