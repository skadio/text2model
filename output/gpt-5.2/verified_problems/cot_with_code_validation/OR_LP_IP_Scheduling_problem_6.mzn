% Maximum Flow

% Parameters
int: n;
int: num_edges;
array[1..num_edges, 1..2] of int: E;   % E[e,1]=tail, E[e,2]=head
array[1..num_edges] of int: a;         % capacities
int: s;                                % source
int: t;                                % sink

set of int: N = 1..n;
set of int: EDGES = 1..num_edges;

% Variables
array[EDGES] of var 0..max(a): f;
var 0..sum(a): maxflow;

% Capacity constraints (lower bound already enforced by domain)
constraint forall(e in EDGES) (f[e] <= a[e]);

% Flow conservation at intermediate nodes:
% sum(inflow) = sum(outflow)
constraint forall(v in N where v != s /\ v != t) (
  sum([f[e] | e in EDGES where E[e,2] == v]) =
  sum([f[e] | e in EDGES where E[e,1] == v])
);

% Define objective flow as total outflow from source (equivalently total inflow to sink)
constraint maxflow = sum([f[e] | e in EDGES where E[e,1] == s]);

solve maximize maxflow;