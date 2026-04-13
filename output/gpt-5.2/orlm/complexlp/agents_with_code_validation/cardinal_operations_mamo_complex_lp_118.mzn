% Maximum flow in a directed capacitated network (8 nodes)

% Parameters
int: n = 8;
set of int: N = 0..n-1;
int: source = 0;
int: sink = 7;

% Capacity matrix (Tbps); 0 means no arc
array[N, N] of int: cap = array2d(N, N,
[
  0,  5, 16, 11,  2, 10, 17,  2,
  8,  0, 14, 14,  2,  7, 11,  1,
 17, 20,  0, 16, 13,  0,  6,  1,
  3, 16, 10,  0, 19, 12,  3, 15,
 15, 12, 19, 18,  0, 14, 12, 15,
  2, 20, 20, 17,  4,  0, 10, 17,
 15, 13, 13,  5, 10, 15,  0, 19,
 10,  3, 14, 11,  5, 20,  4,  0
]);

int: max_cap = max([cap[i,j] | i in N, j in N]);

% Variables
array[N, N] of var 0..max_cap: flow;
var 0..(n * max_cap): total_flow;

% Constraints

% Capacity constraints (also implies 0 flow where cap is 0)
constraint forall(i in N, j in N) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in N) (
  flow[i,i] = 0
);

% Flow conservation for intermediate nodes
constraint forall(k in N where k != source /\ k != sink) (
  sum(j in N)(flow[k,j]) = sum(i in N)(flow[i,k])
);

% Total flow definition (net outflow from source)
constraint total_flow =
  sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Sink net inflow equals total flow
constraint total_flow =
  sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize total_flow;