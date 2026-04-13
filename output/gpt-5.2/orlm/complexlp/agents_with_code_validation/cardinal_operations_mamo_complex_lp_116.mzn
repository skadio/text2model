% Parameters
int: n = 9;                               % number of data centers (0..8)
set of int: N = 0..n-1;                   % node indices
int: source = 0;                          % source node
int: sink = 8;                            % sink node

% Capacity matrix cap[i,j] (TB/hour). 0 means no direct arc i->j.
% Use array2d to coerce the literal matrix (1..n,1..n) into (0..n-1,0..n-1).
array[N, N] of int: cap = array2d(N, N,
[
  0, 11, 11, 14,  6, 11,  4, 15,  9,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0
]);

int: total_out_source = sum(j in N)(cap[source, j]);  % upper bound on max flow

% Variables
array[N, N] of var 0..total_out_source: flow;  % flow[i,j] on arc i->j (TB/hour)
var 0..total_out_source: max_flow;             % total flow from source to sink

% Constraints

% Capacity feasibility on each directed arc
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% No self-loops
constraint forall(i in N) (flow[i,i] = 0);

% Flow conservation at intermediate nodes
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
  );

% Define max_flow as net outflow from source
constraint
  sum(j in N)(flow[source, j]) - sum(i in N)(flow[i, source]) = max_flow;

% Define max_flow as net inflow to sink
constraint
  sum(i in N)(flow[i, sink]) - sum(j in N)(flow[sink, j]) = max_flow;

% Objective
solve maximize max_flow;