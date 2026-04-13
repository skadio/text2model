% Aquaville Max Flow: Station 0 (source) to Station 8 (sink)
% All capacities embedded directly in the model.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[| 0,  2,  8, 17, 16, 20, 15, 12,  9
 | 4,  0, 11,  7,  3, 19, 10, 19,  8
 |14,  7,  0,  7, 13, 19, 18, 20,  5
 |17, 17,  7,  0, 11,  7, 17,  0, 10
 |20, 10,  2, 18,  0, 15,  8,  6, 18
 | 4,  9, 12,  1, 17,  0,  0, 13, 18
 |12, 15, 12, 19, 18, 19,  0,  6, 17
 |14,  1, 17, 20, 11, 20,  6,  0,  4
 |19,  3, 19, 12,  8, 18, 17, 13,  0 |];

% Flow on each directed arc
array[V, V] of var 0..max(cap): f;

% Total flow value (out of source, equivalently into sink)
var 0..sum(j in V)(cap[s,j]): F;

constraint
  forall(i, j in V) (
    f[i,j] <= cap[i,j]
  )
  /\ forall(i in V) (
       f[i,i] = 0
     )
  /\ forall(k in V where k != s /\ k != t) (
       sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
     )
  /\ F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s])
  /\ F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [
  "Maximum flow from station ", show(s), " to station ", show(t), " = ", show(F), " (thousand gallons/hour)\n"
];