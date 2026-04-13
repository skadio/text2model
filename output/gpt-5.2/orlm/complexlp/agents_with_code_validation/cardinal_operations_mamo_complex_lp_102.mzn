% Parameters
int: n = 7;                                  % Number of data centers (nodes)
set of int: N = 0..n-1;                      % Node indices
int: source = 0;                             % Source node (Data Center 0)
int: sink   = 6;                             % Sink node (Data Center 6)

array[N, N] of int: cap =                    % Capacity matrix (Tbps); 0 = no direct link
  array2d(N, N, [
    % to:  0   1   2   3   4   5   6    % from:
          0, 18,  2, 10, 17,  0, 12,    % 0
         14,  0,  3,  1, 19, 18,  2,    % 1
         17,  5,  0, 15, 15, 19,  0,    % 2
         14, 17,  0,  0, 19,  9, 16,    % 3
          2, 13, 15, 12,  0, 20,  5,    % 4
          9, 16,  4, 15, 15,  0, 11,    % 5
          8, 10, 19, 19, 17, 16,  0     % 6
  ]);

int: max_cap = max([cap[i,j] | i in N, j in N]);           % Largest arc capacity
int: max_total_out_source = sum(j in N)(cap[source,j]);    % Upper bound on max flow

% Variables
array[N, N] of var 0..max_cap: flow;         % Flow on arc i->j (Tbps)
var 0..max_total_out_source: total_flow;     % Total flow from source to sink (Tbps)

% Constraints

% --- Capacity / arc existence constraints ---
% If there is no direct link (cap = 0), enforce zero flow on that arc.
constraint
  forall(i in N, j in N where cap[i,j] = 0) (
    flow[i,j] = 0
  );

% Enforce capacity upper bounds on existing arcs.
constraint
  forall(i in N, j in N) (
    flow[i,j] <= cap[i,j]
  );

% Do not allow self-loop flow.
constraint
  forall(i in N) (
    flow[i,i] = 0
  );

% --- Flow conservation constraints ---
% For every intermediate node, inflow equals outflow.
constraint
  forall(k in N where k != source /\ k != sink) (
    sum(i in N)(flow[i,k]) = sum(j in N)(flow[k,j])
  );

% --- Source/sink flow definition constraints ---
% Total flow equals net outflow from source.
constraint
  total_flow = sum(j in N)(flow[source,j]) - sum(i in N)(flow[i,source]);

% Total flow equals net inflow to sink.
constraint
  total_flow = sum(i in N)(flow[i,sink]) - sum(j in N)(flow[sink,j]);

% Objective
solve maximize total_flow;