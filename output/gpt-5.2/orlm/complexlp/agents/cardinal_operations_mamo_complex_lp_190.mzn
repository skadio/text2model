% Parameters
% Number of nodes
int: N = 4;
set of int: Nodes = 1..N;

% Source and sink nodes
int: s = 1;
int: t = 4;

% Directed edges (from, to) and their capacities
int: M = 5;                       % number of edges
set of int: E = 1..M;

array[E] of int: from = [1, 1, 2, 2, 3];
array[E] of int: to   = [2, 3, 3, 4, 4];
array[E] of int: cap  = [5, 7, 2, 4, 12];

% Maximum possible flow value (simple safe upper bound: total capacity leaving source)
int: U = sum(e in E where from[e] = s)(cap[e]);

% Variables
% Flow on each directed edge (bounded by capacity)
array[E] of var 0..U: f;

% Total flow value from source to sink
var 0..U: maxFlow;

% Constraints
%--- Capacity constraints: flow on each edge cannot exceed its capacity ---
constraint
  forall(e in E) (
    f[e] <= cap[e]
  );

%--- Flow conservation at intermediate nodes (all except source and sink) ---
% For each node v != s,t: total inflow equals total outflow
constraint
  forall(v in Nodes where v != s /\ v != t) (
    sum(e in E where to[e] = v)(f[e]) = sum(e in E where from[e] = v)(f[e])
  );

%--- Define maxFlow as total flow leaving the source ---
constraint
  maxFlow = sum(e in E where from[e] = s)(f[e]);

%--- Sink inflow consistency: maxFlow equals total flow entering the sink ---
constraint
  maxFlow = sum(e in E where to[e] = t)(f[e]);

% Objective
solve maximize maxFlow;