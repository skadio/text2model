include "globals.mzn";

% Max flow from Reservoir 0 (source) to Reservoir 8 (sink)

int: n = 9;
set of int: N = 0..n-1;
int: s = 0;
int: t = 8;

% Capacity matrix c[i,j] (0 means no arc)
array[N, N] of int: c =
[
% to:  0  1  2  3  4  5  6  7  8
/*0*/ [0, 6, 1,14,20, 6,13,13,15],
/*1*/ [2, 0, 5, 5,13, 5,12, 9,15],
/*2*/ [15,0, 0, 8,16, 9,19,15, 6],
/*3*/ [13,8, 0, 0,14,12, 9, 1, 2],
/*4*/ [4,14,19,16, 0,14,11,11, 2],
/*5*/ [19,18,5,20, 9, 0,11, 5, 7],
/*6*/ [11,14,20,17,11,13, 0,11,16],
/*7*/ [6, 2,17, 0,10,13,17, 0, 9],
/*8*/ [8, 9, 7,18,12,13, 5, 9, 0]
];

% Decision variables: flow on each directed arc
array[N, N] of var 0..20: f;

% Capacity constraints (also forces f=0 when c=0)
constraint forall(i in N, j in N) (
  f[i,j] <= c[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in N where v != s /\ v != t) (
  sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
);

% Objective: maximize net flow out of source (equivalently into sink)
var int: maxflow = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow from ", show(s), " to ", show(t), " = ", show(maxflow), "\n",
  "Flow matrix f (rows=from, cols=to):\n",
  show(f), "\n"
];