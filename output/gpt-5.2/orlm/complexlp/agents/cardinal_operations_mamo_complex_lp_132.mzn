% Parameters
int: n = 8;                                  % number of nodes
set of int: N = 0..n-1;                       % node indices

int: source = 0;                              % source node (Power Plant)
int: sink   = 7;                              % sink node (Final Distribution Center)

array[N, N] of int: cap =                     % capacity matrix (0 = no arc)
[
% to:   0  1  2  3  4  5  6  7
        0, 2, 1, 1, 8,17, 6, 7,   % from 0
        4, 0,14,14,13,19, 4,19,   % from 1
        6,16, 0, 3,10, 7,18,10,   % from 2
       19, 4,15, 0, 6, 1,17, 9,   % from 3
       12,15, 3,14, 0,18,20,14,   % from 4
       20, 5,19, 9,20, 0,10, 6,   % from 5
        9,14,12,16,19, 3, 0,10,   % from 6
       20,16, 6,16, 8,16, 4, 0    % from 7
];

int: maxCap = max([cap[i,j] | i in N, j in N]); % upper bound for any arc flow

% Variables
array[N, N] of var 0..maxCap: flow;           % flow on each directed arc i->j
var 0..(n*maxCap): total_flow;                % net flow from source to sink (objective)

% Constraints

% --- Capacity constraints (also enforces 0 flow when cap=0) ---
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation for intermediate nodes ---
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(i in N)(flow[i,v]) = sum(j in N)(flow[v,j])
  );

% --- Define total flow as net outflow from source ---
constraint
  total_flow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% --- And equivalently as net inflow to sink (consistency) ---
constraint
  total_flow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize total_flow;