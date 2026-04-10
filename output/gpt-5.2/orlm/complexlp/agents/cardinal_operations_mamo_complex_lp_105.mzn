% Parameters
int: n = 8;                           % number of relay stations (nodes)
set of int: N = 0..n-1;               % node index set
int: source = 0;                      % source node
int: sink = 7;                        % destination (sink) node

array[N, N] of int: cap =             % capacity matrix (Tbps); 0 means no arc
[
  % to:   0  1  2  3  4  5  6  7
  /*0*/ [ 0, 3, 3, 5,13, 7,14,17],
  /*1*/ [ 5, 0, 0, 2,18,20, 1,17],
  /*2*/ [ 2,18, 0,10,14,15, 8,18],
  /*3*/ [20, 7,11, 0,13, 2, 8,12],
  /*4*/ [20,20,12, 7, 0,11, 2,14],
  /*5*/ [ 5,16,15,19,11, 0, 1, 8],
  /*6*/ [10, 3,14,18,13, 6, 0, 7],
  /*7*/ [ 9, 3,14,13, 6, 5, 9, 0]
];

int: cap_ub = max([cap[i,j] | i in N, j in N]);  % global upper bound for any single arc flow

% Variables
array[N, N] of var 0..cap_ub: flow;   % flow on each directed arc (Tbps), bounded globally
var 0..(sum(j in N) (cap[source, j])): total_flow; % total flow sent from source (Tbps)

% Constraints
% --- Capacity constraints (element-wise) ---
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% --- Define total flow as net outflow from source ---
constraint
  total_flow = sum(j in N) (flow[source, j]) - sum(i in N) (flow[i, source]);

% --- Flow conservation at intermediate nodes (no net creation/loss) ---
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N) (flow[i,k]) = sum(j in N) (flow[k,j])
  );

% --- Source/sink consistency: net inflow to sink equals total_flow ---
constraint
  total_flow =
    sum(i in N) (flow[i, sink]) - sum(j in N) (flow[sink, j]);

% --- No self-loop flow (cap[i,i]=0 already implies this, but kept for clarity) ---
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% Objective
solve maximize total_flow;