% Maximum flow from source (0) to sink (8) in a directed capacitated network

int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[
% to:   0  1  2  3  4  5  6  7  8
        [0,15, 1, 9,18,12,18, 6,17], % from 0
        [14,0,13,11,14,10,15, 4,15], % from 1
        [3, 0,0, 2,14,16, 7,12, 4], % from 2
        [5,20,0, 0, 9, 1,12, 1,20], % from 3
        [11,18,12,3, 0, 4,16,15, 2], % from 4
        [13, 8, 8,6, 4, 0, 8,10,11], % from 5
        [12, 1, 3,4,11, 8, 0,10,19], % from 6
        [18, 3, 9,5, 9,17,10, 0,13], % from 7
        [9, 8,12,2, 5, 2,16, 5, 0]  % from 8
];

array[V, V] of var 0..max(cap): f;

% Capacity constraints (also forces f=0 when cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective as total flow leaving source (equivalently entering sink)
var int: maxflow = sum(j in V)(f[s,j]);

solve maximize maxflow;

output [
  "Maximum flow (TB/hour) from station ", show(s), " to station ", show(t), ": ",
  show(maxflow), "\n"
];