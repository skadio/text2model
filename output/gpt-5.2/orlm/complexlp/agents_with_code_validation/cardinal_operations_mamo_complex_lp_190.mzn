% Parameters
int: N = 4;                                 % number of nodes
set of int: Nodes = 1..N;                   % node index set

int: E = 5;                                 % number of directed edges
set of int: Edges = 1..E;                   % edge index set

array[Edges] of int: from = [1, 1, 2, 2, 3]; % tail node of each edge
array[Edges] of int: to   = [2, 3, 3, 4, 4]; % head node of each edge
array[Edges] of int: cap  = [5, 7, 2, 4, 12];% capacity of each edge (nonnegative)

int: s = 1;                                  % source node
int: t = 4;                                  % sink node

int: maxCap = max(cap);                      % helper for bounds
int: maxFlowUB = sum(cap);                   % safe upper bound for total flow value

% Variables
array[Edges] of var 0..maxCap: f;            % flow on each directed edge
var 0..maxFlowUB: totalFlow;                 % total flow from source (equals into sink)

% Constraints

%--- Capacity constraints (bounds are already enforced by variable domains) ---
% Ensure each edge flow does not exceed its specific capacity.
constraint
  forall(e in Edges) (
    f[e] <= cap[e]
  );

%--- Flow conservation constraints at intermediate nodes ---
% For all nodes except source and sink: total inflow equals total outflow.
constraint
  forall(v in Nodes where v != s /\ v != t) (
    sum(e in Edges where to[e] = v)(f[e]) = sum(e in Edges where from[e] = v)(f[e])
  );

%--- Define totalFlow as net outflow from source ---
constraint
  totalFlow =
    sum(e in Edges where from[e] = s)(f[e]) - sum(e in Edges where to[e] = s)(f[e]);

%--- Ensure totalFlow equals net inflow to sink (consistency check) ---
constraint
  totalFlow =
    sum(e in Edges where to[e] = t)(f[e]) - sum(e in Edges where from[e] = t)(f[e]);

% Objective
solve maximize totalFlow;