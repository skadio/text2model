% Parameters
int: nNodes = 4;                              % number of nodes
set of int: NODES = 1..nNodes;                % node index set

int: nArcs = 5;                               % number of directed edges (arcs)
set of int: ARCS = 1..nArcs;                  % arc index set

array[ARCS] of int: from = [1, 1, 2, 2, 3];   % tail node of each arc
array[ARCS] of int: to   = [2, 3, 3, 4, 4];   % head node of each arc
array[ARCS] of int: cap  = [8, 7, 2, 4, 12];  % capacity of each arc

int: source = 1;                              % source node
int: sink   = 4;                              % sink node

int: maxCapSum = sum(a in ARCS)(cap[a]);      % safe upper bound on total flow

% Variables
array[ARCS] of var 0..maxCapSum: flow;        % flow on each arc
var 0..maxCapSum: maxFlow;                    % total flow value from source to sink

% Constraints

% --- Arc capacity constraints: each arc flow cannot exceed its capacity
constraint
  forall(a in ARCS) (
    flow[a] <= cap[a]
  );

% --- Flow conservation constraints: for every intermediate node, inflow = outflow
constraint
  forall(v in NODES where v != source /\ v != sink) (
    sum(a in ARCS where to[a] = v)(flow[a]) =
    sum(a in ARCS where from[a] = v)(flow[a])
  );

% --- Define maxFlow as total outflow from source (equivalently, net flow from source)
constraint
  maxFlow = sum(a in ARCS where from[a] = source)(flow[a]);

% --- Consistency check: maxFlow equals total inflow to sink as well
constraint
  maxFlow = sum(a in ARCS where to[a] = sink)(flow[a]);

% Objective
solve maximize maxFlow;