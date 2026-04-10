% Maximum flow from City 0 (source) to City 5 (sink) with embedded data

int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
[
 % to:   0   1   2   3   4   5   <- from
        [0, 17, 14, 13, 11,  3],  % 0
        [1,  0, 18, 14, 12, 16],  % 1
        [5,  1,  0,  7,  2,  5],  % 2
        [10,13, 19,  0,  4, 16],  % 3
        [3,  0, 13,  0,  0, 14],  % 4
        [15,16,  4,  1, 16,  0]   % 5
];

array[V, V] of var 0..max(cap): f;

% Capacity constraints (including no-arc where cap=0 forces f=0)
constraint forall(i,j in V) ( f[i,j] <= cap[i,j] );

% Flow conservation on intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Objective: maximize net flow out of source (equivalently into sink)
var int: totalFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize totalFlow;

output [
  "Maximum trains per day from City ", show(s), " to City ", show(t), ": ",
  show(totalFlow), "\n"
];