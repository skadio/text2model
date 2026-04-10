% Parameters
int: N = 6;                          % number of points (0..5)
set of int: V = 0..N-1;              % node index set
int: source = 0;                     % data center
int: sink   = 5;                     % user hub

array[V, V] of int: cap =            % capacity matrix (GB/s), 0 means no arc
[|  0, 14,  9,  8,  7,  8
 |  4,  0,  9, 10,  0, 12
 |  4, 12,  0, 13, 20, 16
 | 10,  8, 12,  0,  0, 18
 |  3, 13, 11, 20,  0,  2
 | 17,  4,  8,  2, 12,  0
 |];

int: max_cap = max([cap[i,j] | i in V, j in V]); % for bounding flow variables


% Variables
array[V, V] of var 0..max_cap: flow; % flow[i,j] is GB/s sent from i to j (0 if no arc)
var 0..sum(j in V)(cap[source,j]): total_flow;   % total GB/s sent from source to sink


% Constraints

% --- Capacity / arc-existence constraints ---
% Enforce that flow on each directed pair (i,j) cannot exceed its capacity (0 => forced to 0).
constraint
  forall(i in V, j in V) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation constraints (Kirchhoff's law) ---
% For every intermediate node, inflow equals outflow.
constraint
  forall(k in V where k != source /\ k != sink) (
    sum(i in V)(flow[i,k]) = sum(j in V)(flow[k,j])
  );

% --- Source and sink accounting constraints ---
% Total flow equals net outflow from the source.
constraint
  total_flow = sum(j in V)(flow[source,j]) - sum(i in V)(flow[i,source]);

% Total flow equals net inflow to the sink.
constraint
  total_flow = sum(i in V)(flow[i,sink]) - sum(j in V)(flow[sink,j]);


% Objective
solve maximize total_flow;