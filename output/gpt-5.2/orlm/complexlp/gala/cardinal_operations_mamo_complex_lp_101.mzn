include "globals.mzn";

% Max-flow on a directed graph with 6 hubs (0..5)
int: N = 6;
set of int: V = 0..N-1;

int: s = 0; % source (dispatch)
int: t = 5; % sink (destination)

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
  [|  0,  7,  8,  1,  2,  4
   | 15,  0, 16,  0,  9, 13
   |  9,  1,  0,  9, 13, 13
   | 10, 11, 19,  0,  1, 12
   | 15, 16,  7, 11,  0, 19
   | 10, 12, 12, 12, 20,  0 |];

% Decision variables: flow on each directed arc
array[V, V] of var 0..max(cap): f;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% No self-flow
constraint forall(i in V)( f[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize total flow into sink (equivalently out of source)
var 0..sum(i in V, j in V)(cap[i,j]): maxflow;
constraint maxflow = sum(i in V)(f[i,t]);

solve maximize maxflow;

output [
  show(maxflow), "\n"
];