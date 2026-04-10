% Parameters
int: nNodes = 8;                              % number of substations (nodes)
set of int: N = 0..nNodes-1;                  % node indices
int: source = 0;                              % source node
int: sink = 7;                                % destination (sink) node

array[N, N] of int: cap =                     % capacity matrix (MW); 0 means no arc
[
| 0, 19,  4,  1,  9, 13,  8, 20
|10,  0, 12, 12,  8, 12,  7,  7
|13, 11,  0,  8,  4,  1,  2,  3
| 4, 12, 13,  0, 18,  6, 19,  8
| 9, 16,  2,  0,  0, 14, 18,  7
|10, 11,  7, 11, 16,  0, 16,  5
|14, 11,  9, 11,  3, 17,  0, 19
|12, 20,  5, 11, 10,  4,  6,  0
];

int: maxCap = max([cap[i,j] | i in N, j in N]);  % upper bound for flows


% Variables
array[N, N] of var 0..maxCap: flow;            % flow on each directed arc (MW)
var 0..(nNodes*maxCap): totalFlow;             % total flow sent from source (MW)


% Constraints

%------------------------------------------------------------
% Capacity / existence constraints: no flow allowed where no arc
%------------------------------------------------------------
constraint
  forall(i in N, j in N where cap[i,j] = 0) (
    flow[i,j] = 0
  );

%------------------------------------------------------------
% Capacity upper bounds (clarifies intent; also ties flow to cap)
%------------------------------------------------------------
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

%------------------------------------------------------------
% Flow conservation at intermediate nodes (Kirchhoff law)
% For all nodes except source and sink: inflow = outflow
%------------------------------------------------------------
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

%------------------------------------------------------------
% Define totalFlow as net outflow from source (= net inflow to sink)
%------------------------------------------------------------
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);


% Objective
solve maximize totalFlow;