% Parameters
int: nNodes = 4;                      % number of nodes
set of int: N = 1..nNodes;            % node index set

int: nEdges = 5;                      % number of directed edges
set of int: E = 1..nEdges;            % edge index set

array[E] of int: from = [1, 1, 2, 2, 3];   % tail node of each edge
array[E] of int: to   = [2, 3, 3, 4, 4];   % head node of each edge
array[E] of int: cap  = [8, 7, 2, 4, 7];   % capacity of each edge (non-negative)

int: source = 1;                      % source node
int: sink   = 4;                      % sink node

% Variables
array[E] of var 0..max(cap): flow;    % flow on each directed edge
var 0..sum(cap): maxFlow;             % total flow value from source to sink

% Constraints

% --- Capacity bounds on each edge (respect given capacities) ---
constraint
  forall(e in E) (
    flow[e] <= cap[e]
  );

% --- Flow value definition: total outgoing flow from source equals maxFlow ---
constraint
  maxFlow = sum(e in E where from[e] == source)(flow[e]);

% --- Flow conservation at intermediate nodes (all nodes except source and sink) ---
constraint
  forall(v in N where v != source /\ v != sink) (
    sum(e in E where to[e] == v)(flow[e]) = sum(e in E where from[e] == v)(flow[e])
  );

% --- Sink consistency: total incoming flow to sink equals maxFlow ---
constraint
  maxFlow = sum(e in E where to[e] == sink)(flow[e]);

% Objective
solve maximize maxFlow;