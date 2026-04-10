% Parameters
int: nHubs = 8;                           % number of hubs (nodes)
set of int: HUB = 0..nHubs-1;             % hub indices
int: source = 0;                          % source hub
int: sink = 7;                            % destination hub

array[HUB, HUB] of int: cap =             % capacity matrix (0 => no arc)
[
  % to:   0  1  2  3  4  5  6  7
  /*0*/ [ 0,15,19, 4, 4, 3,20,17],
  /*1*/ [ 8, 0, 6, 5,20, 3,15, 1],
  /*2*/ [11,13, 0,16,15, 7,10,13],
  /*3*/ [17,20, 6, 0,11, 3, 2, 0],
  /*4*/ [10,15, 5, 0, 0, 9, 9,15],
  /*5*/ [ 9,17, 5, 1, 9, 0,20, 2],
  /*6*/ [ 4,16,10, 2, 1, 6, 0, 4],
  /*7*/ [ 0, 0, 0, 0, 0, 0, 0, 0]
];

% Upper bound on total flow (safe bound: total outbound capacity from source)
int: maxFlowUB = sum(j in HUB)(cap[source,j]);

% Variables
array[HUB, HUB] of var 0..maxFlowUB: flow;  % flow on each directed arc (bounded above globally)
var 0..maxFlowUB: maxFlow;                  % total flow sent from source to sink


% Constraints

% Capacity constraints: flow on each arc cannot exceed its capacity (and is 0 if no arc)
constraint
  forall(i in HUB, j in HUB) (
    flow[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate hubs (all except source and sink)
constraint
  forall(h in HUB where h != source /\ h != sink) (
    sum(j in HUB)(flow[h,j]) = sum(i in HUB)(flow[i,h])
  );

% Define total flow value as net outflow from the source
constraint
  maxFlow = sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]);

% Ensure consistency: same total flow equals net inflow to the sink
constraint
  maxFlow = sum(i in HUB)(flow[i,sink]) - sum(j in HUB)(flow[sink,j]);


% Objective
solve maximize maxFlow;