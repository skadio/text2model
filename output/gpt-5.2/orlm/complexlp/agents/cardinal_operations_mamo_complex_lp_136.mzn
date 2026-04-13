% Parameters
int: nHubs = 7;                       % number of hubs (0..6)
set of int: H = 0..nHubs-1;           % hub indices
int: source = 0;                      % Central Dispatch
int: sink   = 6;                      % Main Distribution Hub

array[H, H] of int: cap =             % capacity matrix (0 => no arc)
[|  0, 15,  2, 16,  3,  5,  3
 |  7,  0,  0,  0, 19, 15, 16
 | 11, 14,  0, 14,  8, 11,  6
 | 17, 11, 11,  0, 11, 16, 19
 | 10,  4, 17, 20,  0, 12, 17
 |  3,  0,  4,  5, 20,  0,  4
 | 15,  2, 15, 18, 17,  7,  0 |];

int: maxCap = max([cap[i,j] | i in H, j in H]); % upper bound for any arc flow


% Variables
array[H, H] of var 0..maxCap: flow;                 % flow on each directed lane
var 0..sum(j in H)(cap[source,j]): totalFlow;       % total flow value (bounded by source outgoing capacity)


% Constraints
% --- Capacity feasibility on each directed lane (0 capacity => no flow) ---
constraint
  forall(i in H, j in H) (
    flow[i,j] <= cap[i,j]
  );

% --- Define totalFlow as net outflow from the source hub ---
constraint
  totalFlow
  = sum(j in H)(flow[source,j]) - sum(i in H)(flow[i,source]);

% --- Define totalFlow as net inflow into the sink hub (consistency check) ---
constraint
  totalFlow
  = sum(i in H)(flow[i,sink]) - sum(j in H)(flow[sink,j]);

% --- Flow conservation at intermediate hubs (no creation/loss of flow) ---
constraint
  forall(k in H where k != source /\ k != sink) (
    sum(j in H)(flow[k,j]) = sum(i in H)(flow[i,k])
  );


% Objective
solve maximize totalFlow;

output [
  "Maximum vehicles/hour from hub ", show(source), " to hub ", show(sink), ": ",
  show(totalFlow), "\n"
];