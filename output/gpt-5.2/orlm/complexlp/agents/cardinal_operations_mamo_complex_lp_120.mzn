% Parameters
int: nHubs = 9;                         % number of hubs (0..8)
set of int: HUB = 0..nHubs-1;           % hub indices
int: source = 0;                        % source hub
int: sink = 8;                          % sink hub

array[HUB, HUB] of int: cap =           % capacity matrix (0 => no arc)
[
% to:   0  1  2  3  4  5  6  7  8
/*0*/ [ 0, 4, 7,15, 4, 7, 2,10,12],
/*1*/ [ 0, 0,17, 2, 5, 1,10,14, 5],
/*2*/ [ 0, 7, 0,17, 9,13,10, 7, 5],
/*3*/ [ 0,16, 4, 0,11, 9,12,18,12],
/*4*/ [ 0, 3, 0,18, 0, 5, 2, 0,19],
/*5*/ [ 0,15, 7,20,20, 0,20,12, 9],
/*6*/ [ 0, 8,14,13, 1,17, 0,10,19],
/*7*/ [ 0, 5, 5,16, 5, 7, 3, 0,19],
/*8*/ [ 0,19,18, 0, 4, 7, 1,20, 0]
];

int: maxCap = max([cap[i,j] | i in HUB, j in HUB]);  % global upper bound for flows


% Variables
array[HUB, HUB] of var 0..maxCap: flow;              % flow sent on arc i->j (0 if no arc)
var 0..sum(j in HUB)(cap[source,j]): totalFlow;      % total flow value (objective)


% Constraints
% --- Capacity / structural constraints (forces flow=0 when cap=0) ---
constraint
  forall(i in HUB, j in HUB) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation at intermediate hubs (all hubs except source and sink) ---
constraint
  forall(h in HUB where h != source /\ h != sink) (
    sum(i in HUB)(flow[i,h]) = sum(j in HUB)(flow[h,j])
  );

% --- Define totalFlow as the total outflow from the source hub ---
constraint
  totalFlow = sum(j in HUB)(flow[source,j]);

% --- Source net outflow equals totalFlow (kept general) ---
constraint
  sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]) = totalFlow;

% --- Sink net inflow equals totalFlow (enforce net inflow) ---
constraint
  sum(i in HUB)(flow[i,sink]) - sum(j in HUB)(flow[sink,j]) = totalFlow;


% Objective
solve maximize totalFlow;