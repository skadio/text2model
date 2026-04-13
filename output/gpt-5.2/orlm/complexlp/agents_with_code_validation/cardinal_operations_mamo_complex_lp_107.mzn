% Maximum flow from source (0) to sink (6) in a directed capacitated network

% Parameters
int: n = 7;                 % number of stations (0..6)
set of int: N = 0..n-1;     % station indices
int: source = 0;
int: sink   = 6;

% Capacity matrix cap[i,j] (0 means no direct link)
% Use array2d to ensure the index set is 0..6 x 0..6 (not 1..7 x 1..7).
array[N, N] of int: cap =
  array2d(N, N,
    [
      0, 17,  3, 20, 11, 11,  3,
     11,  0, 12, 18,  5,  6,  4,
      7,  2,  0, 15, 13, 20, 18,
      7,  4,  2,  0,  2, 15,  3,
     19, 12, 16,  4,  0, 19,  4,
     13, 20, 10, 14, 15,  0,  1,
      3,  3,  6, 20,  9, 10,  0
    ]
  );

int: max_cap = max([cap[i,j] | i in N, j in N]);
int: max_total_out = sum(j in N)(cap[source, j]);

% Decision variables
array[N, N] of var 0..max_cap: flow;   % flow on arc i->j
var 0..max_total_out: total_flow;

% Constraints

% Capacity constraints (also forces 0-capacity arcs to carry 0 flow)
constraint forall(i in N, j in N) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in N) (
  flow[i,i] = 0
);

% Flow conservation at intermediate stations
constraint forall(k in N where k != source /\ k != sink) (
  sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
);

% Define total flow as net outflow from source
constraint
  total_flow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Redundant strengthening: total flow equals net inflow to sink
constraint
  total_flow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize total_flow;

% Optional output
output [
  "max_flow = ", show(total_flow), "\n"
];