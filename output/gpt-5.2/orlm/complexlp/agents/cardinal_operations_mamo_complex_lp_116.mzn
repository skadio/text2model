% Parameters
int: n = 9;                         % number of data centers (0..8)
set of int: N = 0..n-1;             % node set
int: source = 0;                    % source node
int: sink = 8;                      % sink node

% Capacity matrix (TB/hour). 0 means no direct arc.
array[N, N] of int: cap =
[
% to:   0  1  2  3  4  5  6  7  8
      [ 0,11,11,14, 6,11, 4,15, 9],  % from 0
      [ 0, 0, 1, 2, 3, 4, 5, 6,20],  % from 1
      [ 0,18, 0, 7, 8,18, 9,10,11],  % from 2
      [ 0,12,13, 0,14,15,16,17,18],  % from 3
      [ 0, 1, 2, 3, 0, 4, 5, 6, 7],  % from 4
      [ 0, 8, 9,10,11, 0,12,13,14],  % from 5
      [ 0,15,16,17,18,19, 0,20, 1],  % from 6
      [ 0, 2, 3, 4, 5, 6, 7, 0, 8],  % from 7
      [ 0, 9,10,11,12,13,14,15, 0]   % from 8
];

int: maxCap = max([cap[i,j] | i in N, j in N]);  % upper bound for arc flow variables


% Variables
array[N, N] of var 0..maxCap: flow;  % flow[i,j] on arc i->j
var 0..sum(j in N)(cap[source,j]): totalFlow;    % total flow value (bounded by source outgoing cap sum)


% Constraints

% --- Capacity feasibility (respect missing arcs and arc limits) ---
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% --- No self-loops (not meaningful in this network) ---
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% --- Flow conservation at intermediate nodes (everything except source and sink) ---
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(u in N)(flow[u,v]) = sum(w in N)(flow[v,w])
  );

% --- Define totalFlow as net outflow from the source (equivalently net inflow to sink) ---
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% --- Ensure consistency with sink: totalFlow equals net inflow to sink ---
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);


% Objective
solve maximize totalFlow;