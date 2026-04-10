% Parameters
int: nHubs = 8;                         % number of hubs (0..7)
set of int: HUB = 0..nHubs-1;           % hub indices
int: source = 0;                        % source hub
int: sink = 7;                          % destination hub

array[HUB, HUB] of int: cap =           % capacity matrix (cap[i,j]=0 means no arc)
  [|  0, 19,  5,  7,  0, 17, 19,  9
   |  6,  0, 15, 15, 16,  8,  5,  0
   |  5,  6,  0,  3, 10,  7,  6,  3
   |  8,  2,  6,  0,  5, 17,  0,  1
   | 17,  4, 10, 10,  0,  6, 15, 14
   | 11, 11,  9,  7,  7,  0, 16, 19
   | 13, 19, 14, 14, 16,  1,  0, 16
   |  0, 14,  0, 17,  1,  7,  9,  0 |];

int: totalCapOutSource = sum(j in HUB)(cap[source, j]);  % upper bound on max flow

% Variables
array[HUB, HUB] of var 0..totalCapOutSource: flow;  % flow[i,j] sent along arc i->j
var 0..totalCapOutSource: maxFlow;                  % total flow delivered from source to sink

% Constraints

% Capacity upper bounds (also forces flow=0 when cap=0)
constraint
  forall(i, j in HUB) (
    flow[i, j] <= cap[i, j]
  );

% No self-loops (hygiene)
constraint
  forall(i in HUB) (
    flow[i, i] = 0
  );

% Define maxFlow as net outflow from the source
constraint
  maxFlow = sum(j in HUB)(flow[source, j]) - sum(i in HUB)(flow[i, source]);

% Flow conservation at intermediate hubs (all except source and sink)
constraint
  forall(k in HUB where k != source /\ k != sink) (
    sum(i in HUB)(flow[i, k]) = sum(j in HUB)(flow[k, j])
  );

% Sink net inflow must equal maxFlow (consistent with source definition + conservation)
constraint
  maxFlow = sum(i in HUB)(flow[i, sink]) - sum(j in HUB)(flow[sink, j]);

% (Optional redundancy) Explicit conservation at source and sink using maxFlow
constraint
  sum(j in HUB)(flow[source, j]) - sum(i in HUB)(flow[i, source]) = maxFlow;

constraint
  sum(i in HUB)(flow[i, sink]) - sum(j in HUB)(flow[sink, j]) = maxFlow;

% Objective
solve maximize maxFlow;