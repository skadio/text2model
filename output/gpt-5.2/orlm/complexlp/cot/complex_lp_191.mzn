% Parameters (with values embedded)
int: N = 4;
set of int: Nodes = 1..N;
int: Source = 1;
int: Sink = 4;

set of int: Edges = 1..5;
array[Edges] of int: from = [1, 1, 2, 2, 3];
array[Edges] of int: to   = [2, 3, 3, 4, 4];
array[Edges] of int: cap  = [8, 7, 2, 4, 7];

% Variables
array[Edges] of var 0..8: f;  % flow on each edge (upper bounded further below)
var 0..100: maxflow;

% Constraints
constraint forall(e in Edges) (f[e] <= cap[e]);

% Flow conservation at intermediate nodes (all except source and sink)
constraint forall(v in Nodes where v != Source /\ v != Sink) (
  sum(e in Edges where to[e] = v)(f[e]) = sum(e in Edges where from[e] = v)(f[e])
);

% Define objective value as net outflow from source (equals inflow to sink under conservation)
constraint maxflow = sum(e in Edges where from[e] = Source)(f[e]) - sum(e in Edges where to[e] = Source)(f[e]);

% Objective
solve maximize maxflow;