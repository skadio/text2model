int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
%      0   1   2   3   4   5
 [|    0,  9, 13,  0, 20, 16  % 0
  |    6,  0, 19, 11, 14, 15  % 1
  |   11,  6,  0,  8,  3, 10  % 2
  |   16,  2, 17,  0,  1, 17  % 3
  |    4, 12,  5, 16,  0, 15  % 4
  |    7, 19, 18,  6,  8,  0  % 5
  |];

array[V, V] of var 0..20: f;  % 20 is the max capacity in the data

% Respect capacities (and force zero flow where no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

var 0..100: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output [
  "Maximum vehicles from city ", show(s), " to city ", show(t),
  " (thousands per hour) = ", show(maxflow), "\n"
];