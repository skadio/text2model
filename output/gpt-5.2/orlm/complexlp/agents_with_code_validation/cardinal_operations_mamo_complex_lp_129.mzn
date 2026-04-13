% Max flow in a directed network (nodes 0..5)

int: nNodes = 6;
set of int: N = 0..nNodes-1;
int: source = 0;
int: sink = 5;

% Capacity matrix (0 means no arc). Use array2d to enforce index set 0..5 x 0..5.
array[N, N] of int: cap =
  array2d(N, N,
  [  0, 11,  8, 11, 20, 16,
    15,  0, 11, 16,  0, 20,
     7,  4,  0,  4, 11,  0,
     4,  8, 14,  0, 19,  0,
    10,  0,  6, 19,  0, 13,
    10, 15, 20, 19, 10,  0
  ]);

int: totalCapOutSource = sum(j in N)(cap[source, j]);

array[N, N] of var 0..totalCapOutSource: flow;
var 0..totalCapOutSource: maxFlow;

% Capacity constraints (+ no self-loops)
constraint forall(i in N, j in N) (flow[i, j] <= cap[i, j]);
constraint forall(i in N) (flow[i, i] = 0);

% Flow conservation for intermediate nodes
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(u in N)(flow[u, v]) = sum(w in N)(flow[v, w])
  );

% Define flow value as net outflow from source (equivalently net inflow to sink)
constraint maxFlow = sum(j in N)(flow[source, j]) - sum(i in N)(flow[i, source]);
constraint maxFlow = sum(i in N)(flow[i, sink]) - sum(j in N)(flow[sink, j]);

solve maximize maxFlow;

% Optional output
output [
  "maxFlow = ", show(maxFlow), "\n"
];