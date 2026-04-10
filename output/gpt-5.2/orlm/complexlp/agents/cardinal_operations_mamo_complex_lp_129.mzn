% Parameters
int: nNodes = 6;                         % number of nodes (0..5)
set of int: N = 0..nNodes-1;             % node index set

int: source = 0;                         % source node
int: sink = 5;                           % sink/destination node

% Capacity matrix (thousands of packets per unit time); 0 means no direct arc
array[N, N] of int: cap =
  array2d(N, N,
  [
    % to:  0,  1,  2,  3,  4,  5    (from row index)
           0, 11,  8, 11, 20, 16,   % from 0
          15,  0, 11, 16,  0, 20,   % from 1
           7,  4,  0,  4, 11,  0,   % from 2
           4,  8, 14,  0, 19,  0,   % from 3
          10,  0,  6, 19,  0, 13,   % from 4
          10, 15, 20, 19, 10,  0    % from 5
  ]);

% Upper bound for each flow variable (largest capacity in the matrix)
int: maxCap = max([cap[i,j] | i in N, j in N]);

% Variables
% Flow on each directed connection (thousands of packets per unit time)
array[N, N] of var 0..maxCap: flow;

% Total flow value sent from source to sink (objective variable)
var 0..(sum(j in N)(cap[source,j])): totalFlow;

% Constraints
% --- Capacity / arc existence constraints ---
% No flow may exceed the given capacity; if cap[i,j]=0 then flow[i,j]=0 automatically
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% Disallow self-loops (also implied since cap[i,i]=0 in given data)
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% --- Flow conservation constraints ---
% For every intermediate node (not source or sink), inflow equals outflow
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% --- Definition of totalFlow ---
% Total flow equals net outflow from source (outflow - inflow)
constraint
  totalFlow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Total flow equals net inflow to sink (inflow - outflow)
constraint
  totalFlow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize totalFlow;