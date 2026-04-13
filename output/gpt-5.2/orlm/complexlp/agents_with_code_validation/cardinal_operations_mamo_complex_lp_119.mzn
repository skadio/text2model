% Maximum Flow (0..5 indexed)

% Parameters
int: n = 6;
set of int: N = 0..n-1;

int: source = 0;
int: sink   = 5;

% Capacity matrix (MW); 0 means no arc
array[N, N] of int: cap =
  array2d(N, N,
    [ 0,  4, 12, 19, 13, 11,
     20,  0, 13,  9, 10,  0,
     14,  8,  0,  5, 13, 11,
      5, 15, 18,  0,  6,  7,
      8, 17, 20, 14,  0,  9,
      9, 19, 19, 11,  4,  0 ]
  );

% Variables
var 0..sum(j in N)(cap[source,j]): maxFlow;
array[N, N] of var 0..max(cap): flow;

% Constraints: capacity bounds (cap=0 forces flow=0)
constraint forall(i in N, j in N)(
  flow[i,j] <= cap[i,j]
);

% Define total s-t flow as net outflow from source
constraint maxFlow =
  sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Flow conservation at intermediate nodes
constraint forall(v in N where v != source /\ v != sink)(
  sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
);

% Objective
solve maximize maxFlow;

output ["maxFlow(MW) = ", show(maxFlow), "\n"];