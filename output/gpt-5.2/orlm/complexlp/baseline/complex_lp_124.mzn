% Maximum flow from City 0 (source) to City 8 (sink)
% Capacities are given in thousands of tons.

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  % to:  0  1  2  3  4  5  6  7  8
         0, 1,16, 8,18, 4, 0, 8, 5,  % from 0
        15, 0,11, 8,13, 2, 1, 7, 6,  % from 1
        15, 4, 0, 3, 1,13,13,11, 9,  % from 2
         4,16, 8, 0,12,18,19, 8,11,  % from 3
         4,19, 3, 2, 0, 6, 1,13,14,  % from 4
         6,19,15,10,16, 0,17,15,17,  % from 5
        13, 7,13, 4,14, 3, 0, 8, 8,  % from 6
        10, 6,19, 1,12, 6, 9, 0,14,  % from 7
         0, 0, 0, 0, 0, 0, 0, 0, 0   % from 8 (unspecified; set to 0)
]);

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Maximize total flow leaving source (equivalently entering sink)
var 0..N*U: maxflow = sum(j in V)(f[s,j]);

solve maximize maxflow;

output [
  "Maximum cargo flow from City ", show(s), " to City ", show(t), " = ",
  show(maxflow), " (thousands of tons)\n"
];