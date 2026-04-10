% Maximum flow in a directed network (nodes 0..5), maximize flow from source to sink.

int: n = 6;
set of int: N = 0..n-1;

int: s = 0;
int: t = 5;

array[N, N] of int: cap =
[
% to:   0   1   2   3   4   5
/*0*/ [ 0, 11,  8, 11, 20, 16],
/*1*/ [15,  0, 11, 16,  0, 20],
/*2*/ [ 7,  4,  0,  4, 11,  0],
/*3*/ [ 4,  8, 14,  0, 19,  0],
/*4*/ [10,  0,  6, 19,  0, 13],
/*5*/ [10, 15, 20, 19, 10,  0]
];

array[N, N] of var 0..max(cap): f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in N, j in N) (
  f[i,j] <= cap[i,j]
);

% No self-flow
constraint forall(i in N) ( f[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint forall(v in N where v != s /\ v != t) (
  sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
);

% Define objective: total outflow from source (equivalently inflow to sink)
var int: maxflow = sum(j in N)(f[s,j]) - sum(i in N)(f[i,s]);
constraint maxflow = sum(i in N)(f[i,t]) - sum(j in N)(f[t,j]);

solve maximize maxflow;

output [
  "Maximum flow (thousands of packets per unit time) = ", show(maxflow), "\n",
  "Flow matrix f[i,j] (i->j):\n"
] ++
[
  if i==0 then "" else "" endif ++
  concat([ " " ++ show(f[i,j]) | j in N ]) ++ "\n"
  | i in N
];