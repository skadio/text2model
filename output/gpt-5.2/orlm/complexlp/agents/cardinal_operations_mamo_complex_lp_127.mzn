% Parameters
int: nNodes = 9;                 % number of nodes
set of int: N = 0..nNodes-1;     % node indices

int: source = 0;                 % source node
int: sink   = 8;                 % sink/destination node

% Capacity matrix (in thousands of units). 0 means no direct arc.
array[N, N] of int: cap =
array2d(N, N, [
  % to:   0  1  2  3  4  5  6  7  8
         0,13,19,17, 7, 7,11, 7, 7,   % from 0
         9, 0,19,20,10,19,20,19, 3,   % from 1
         0,16, 0, 0,10, 2,14, 9, 9,   % from 2
         6, 0, 5, 0, 7,18,15,20, 7,   % from 3
        18,19,12, 0, 0,16,20,10, 4,   % from 4
         3, 4, 8, 9,20, 0, 7, 8, 1,   % from 5
         3,14,14,16, 1,12, 0,10,10,   % from 6
         9,20,19, 4, 9,16, 1, 0, 6,   % from 7
         7,15,14,18,18,11,18, 0, 0    % from 8 (as given; last entry irrelevant)
]);

% A safe upper bound on any flow value (sum of all capacities).
int: U = sum(i in N, j in N)(cap[i,j]);

% Variables
array[N, N] of var 0..U: flow;   % flow on each directed arc (thousands of units)
var 0..U: maxFlow;               % total flow from source to sink (thousands of units)

% Constraints

% --- Capacity / arc existence constraints ---
% Enforce that flow on each arc does not exceed its capacity (and is 0 if no arc).
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation constraints ---
% For all intermediate nodes (excluding source and sink), inflow equals outflow.
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% --- Define maxFlow consistently with source and sink balances ---
% Total net outflow from the source equals maxFlow.
constraint
  maxFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Total net inflow to the sink equals maxFlow.
constraint
  maxFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize maxFlow;