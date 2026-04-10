% Parameters
int: n = 8;                                % number of data centers (nodes)
set of int: N = 0..n-1;                    % node indices
int: source = 0;                           % source node
int: sink = 7;                             % sink node

% Bandwidth capacities (TB/h); 0 = no arc
% Use array2d to coerce the literal matrix to index set 0..7 x 0..7
array[N, N] of int: cap =
  array2d(N, N,
  [  0,  6, 16,  5,  6, 11,  6,  4,
     0,  0,  8, 10,  6,  3,  6, 14,
     0,  6,  0, 20,  7, 16, 13, 14,
     0, 11, 19,  0, 18,  5,  0,  8,
     0,  1, 14, 18,  0, 12,  4,  7,
     0, 16,  3, 20,  7,  0, 15,  6,
     0, 11,  4, 19,  7,  6,  0, 17,
     0,  5,  8, 17,  2,  5,  4,  0
  ]);

int: maxCap = max([cap[i,j] | i in N, j in N]);   % maximum single-arc capacity
int: flow_ub = maxCap * (n-1);                    % safe upper bound on total flow value

% Variables
array[N, N] of var 0..maxCap: f;          % flow on arc i->j (TB/h), bounded by maxCap
var 0..flow_ub: totalFlow;                % total flow value from source to sink

% Constraints

% Capacity enforcement / arc existence (if cap=0 then f=0 via f<=cap)
constraint
  forall(i in N, j in N) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate nodes
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(i in N)(f[i,v]) = sum(j in N)(f[v,j])
  );

% Define totalFlow as net outflow from source
constraint
  totalFlow = sum(j in N)(f[source,j]) - sum(i in N)(f[i,source]);

% Consistency: same value equals net inflow into sink
constraint
  totalFlow = sum(i in N)(f[i,sink]) - sum(j in N)(f[sink,j]);

% Objective
solve maximize totalFlow;