% Parameters
int: n = 9;                               % number of data centers (stations)
set of int: N = 0..n-1;                   % station indices
int: source = 0;                          % source station
int: sink = 8;                            % destination (sink) station

array[N, N] of int: cap =                 % capacity matrix cap[i,j] (Tbps); 0 = no arc
array2d(N, N,
[
  % to:   0  1  2  3  4  5  6  7  8
          0, 6,20,15, 9,20,17,16,20,   % from 0
          6, 0,10, 3, 7, 2, 8,18,10,   % from 1
         20,10, 0, 6,19,12, 5, 7, 8,   % from 2
         15, 3, 6, 0, 4, 5, 6, 4,20,   % from 3
          9, 7,19, 4, 0, 2, 3, 6, 3,   % from 4
         20, 2,12, 5, 2, 0,10, 7, 3,   % from 5
         17, 8, 5, 6, 3,10, 0, 5, 4,   % from 6
         16,18, 7,20, 6, 7, 5, 0, 5,   % from 7
         20,10, 8,20, 3, 3, 4, 5, 0    % from 8
]);

int: max_cap = max([cap[i,j] | i in N, j in N]);  % used for safe variable bounds

% Variables
array[N, N] of var 0..max_cap: flow;     % flow[i,j] sent on arc i->j (Tbps), bounded by max_cap
var 0..(n*max_cap): max_flow;            % total s-t flow value (Tbps), safe upper bound

% Constraints

% Capacity constraints: flow on each directed arc cannot exceed its capacity;
% if cap[i,j] = 0 then this forces flow[i,j] = 0 as well.
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% No self-loop flow (optional clarity; also implied by cap[i,i] = 0)
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate nodes: inflow = outflow for all nodes
% except source and sink.
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% Define max_flow as net outflow from source (equivalently, net inflow to sink).
constraint
  max_flow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Consistency check: same max_flow must arrive at sink.
constraint
  max_flow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize max_flow;