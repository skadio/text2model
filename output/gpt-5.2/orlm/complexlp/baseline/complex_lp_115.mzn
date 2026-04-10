% Max flow from City 0 to City 6 with embedded data

int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
[
% to:    0  1  2  3  4  5  6
/*0*/ [  0,20,19,18, 0,11, 2],
/*1*/ [ 18, 0,15,10, 0, 9, 0],
/*2*/ [ 18, 4, 0,11,15, 0,13],
/*3*/ [ 17, 3,15, 0, 2, 4, 4],
/*4*/ [  2,11,17,17, 0, 2,17],
/*5*/ [ 12, 4,16,13, 5, 0, 3],
/*6*/ [  7, 9,17,18,16, 8, 0]
];

array[V, V] of var 0..max(cap): f;

% Capacity constraints (also forces 0 flow where no arc exists)
constraint forall(i,j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective as net outflow from source (equals inflow to sink by conservation)
var 0..sum(j in V)(cap[s,j]): maxflow;
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (thousand kg/day) = ", show(maxflow), "\n",
  "Flow matrix f[i,j] (thousand kg/day):\n"
] ++
[
  if j = 0 then "from " ++ show(i) ++ ": " else "" endif ++
  show(f[i,j]) ++ (if j = N-1 then "\n" else " " endif)
  | i in V, j in V
];