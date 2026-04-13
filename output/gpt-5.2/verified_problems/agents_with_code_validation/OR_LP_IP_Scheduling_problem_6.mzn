% Parameters
int: n;                              % Number of nodes
int: num_edges;                      % Number of arcs
array[1..num_edges, 1..2] of int: E; % Arc list: E[e,1]=from-node, E[e,2]=to-node
array[1..num_edges] of int: a;       % Capacity of each arc (non-negative)
int: s;                              % Source node
int: t;                              % Sink node

% Variables
int: maxCap = sum(e in 1..num_edges)(a[e]); % Upper bound on total flow (sum of all capacities)
array[1..num_edges] of var 0..maxCap: f;    % Flow on each arc
var 0..maxCap: total_flow;                  % Total flow value (source net outflow = sink net inflow)

% Constraints

%-------------------------------
% Capacity constraints on arcs
%-------------------------------
constraint
  forall(e in 1..num_edges) (
    f[e] <= a[e]
  );

%---------------------------------------------
% Flow conservation at intermediate (non s,t)
%---------------------------------------------
constraint
  forall(v in 1..n where v != s /\ v != t) (
    sum(e in 1..num_edges where E[e,2] == v)(f[e])   % inflow to v
    =
    sum(e in 1..num_edges where E[e,1] == v)(f[e])   % outflow from v
  );

%---------------------------------------------------------
% Define total_flow as net outflow from source (s)
%---------------------------------------------------------
constraint
  total_flow =
    sum(e in 1..num_edges where E[e,1] == s)(f[e])   % out of source
    -
    sum(e in 1..num_edges where E[e,2] == s)(f[e]);  % into source (if any)

%---------------------------------------------------------
% Define total_flow as net inflow to sink (t) (consistency)
%---------------------------------------------------------
constraint
  total_flow =
    sum(e in 1..num_edges where E[e,2] == t)(f[e])   % into sink
    -
    sum(e in 1..num_edges where E[e,1] == t)(f[e]);  % out of sink (if any)

% Objective
solve maximize total_flow;