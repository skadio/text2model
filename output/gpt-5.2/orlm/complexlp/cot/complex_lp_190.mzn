% Parameters (with values embedded)
int: N = 4;
set of int: V = 1..N;

int: source = 1;
int: sink = 4;

int: M = 5;
set of int: E = 1..M;

array[E] of int: from = [1, 1, 2, 2, 3];
array[E] of int: to   = [2, 3, 3, 4, 4];
array[E] of int: cap  = [5, 7, 2, 4, 12];

% Variables
array[E] of var 0..12: f;          % flow on each edge (12 is max capacity)
var 0..100: maxFlow;               % value of the flow (safe upper bound)

% Constraints
constraint forall(e in E) (f[e] <= cap[e]);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != source /\ v != sink) (
  sum(e in E where to[e] = v)(f[e]) = sum(e in E where from[e] = v)(f[e])
);

% Define maxFlow as net outflow from source (equivalently inflow to sink)
constraint maxFlow = sum(e in E where from[e] = source)(f[e]) - sum(e in E where to[e] = source)(f[e]);
constraint maxFlow = sum(e in E where to[e] = sink)(f[e]) - sum(e in E where from[e] = sink)(f[e]);

% Objective
solve maximize maxFlow;