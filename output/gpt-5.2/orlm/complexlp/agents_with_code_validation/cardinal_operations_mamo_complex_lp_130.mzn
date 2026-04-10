% Parameters
int: nNodes = 8;                          % number of nodes
set of int: N = 0..nNodes-1;              % node indices
int: source = 0;                          % source node
int: sink = 7;                            % sink node

% Capacity matrix (0 means no arc)
array[N, N] of int: cap = array2d(N, N, [
  % to:   0,  1,  2,  3,  4,  5,  6,  7
          0,  3,  7,  2, 18, 18, 14, 10,   % from 0
          1,  0, 10, 16, 14,  0,  6, 10,   % from 1
          4,  0,  0,  7,  2,  2,  6, 10,   % from 2
          2,  3,  7,  0, 20,  8,  6, 10,   % from 3
          1, 20,  4,  8,  0, 13,  8,  1,   % from 4
         16,  9, 17, 17, 11,  0,  7,  8,   % from 5
          3,  7, 14,  1, 20,  5,  0, 13,   % from 6
          0,  0,  0,  0,  0,  0,  0,  0    % from 7 (no outgoing arcs specified/needed)
]);

% Safe upper bound on total flow value (sum of outgoing capacities from source)
int: maxTotalFlow = sum(j in N)(cap[source, j]);

% Variables
array[N, N] of var 0..maxTotalFlow: flow; % flow on each directed arc (i->j)
var 0..maxTotalFlow: totalFlow;           % total flow from source to sink

% Constraints

%------------------------------------------------------------
% Arc capacity feasibility (also enforces flow=0 when cap=0)
%------------------------------------------------------------
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

%------------------------------------------------------------
% Flow conservation at transshipment (intermediate) nodes
% inflow == outflow for all v != source,sink
%------------------------------------------------------------
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
  );

%------------------------------------------------------------
% Define totalFlow as net outflow from the source
%------------------------------------------------------------
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

%------------------------------------------------------------
% Define totalFlow as net inflow to the sink (consistency check)
%------------------------------------------------------------
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;