% Maximum flow from source 0 to sink 8 in a directed capacitated network
% Nodes: 0..8
% All data embedded.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
[
%  j: 0  1  2  3  4  5  6  7  8
    0,11,11,14, 6,11, 4,15, 9,  % i=0
    0, 0,20, 1, 3, 4, 2, 5, 6,  % i=1
    0,18, 0, 7, 8,18, 1, 9,10,  % i=2
    0, 5, 6, 0,12, 2,14, 3, 4,  % i=3
    0, 7, 8, 9, 0,10, 2, 1,11,  % i=4
    0, 4,18, 3, 2, 0, 6, 7, 5,  % i=5
    0, 2, 1,15, 4, 6, 0, 8, 3,  % i=6
    0, 9, 5, 2, 1, 7, 8, 0,13,  % i=7
    0, 3, 2, 4, 5, 6, 7, 8, 0   % i=8
];

set of (int,int): A = { (i,j) | i in V, j in V where cap[i,j] > 0 };

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;

% Capacity constraints and zero flow on non-arcs
constraint
  forall(i in V, j in V) (
    if cap[i,j] > 0 then
      f[i,j] <= cap[i,j]
    else
      f[i,j] = 0
    endif
  );

% Flow conservation on intermediate nodes
constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

% Objective: maximize total flow out of s (equivalently into t)
var 0..U: maxflow = sum(j in V)(f[s,j]);

solve maximize maxflow;

output [
  "Maximum information flow from ", show(s), " to ", show(t), " = ",
  show(maxflow), " TB/hour\n"
];