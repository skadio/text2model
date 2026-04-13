% Parameters
%-----------------------------
% Maximum flow on a directed graph (embedded data)
%-----------------------------
int: N = 4;
set of int: Nodes = 1..N;

int: E = 5;
set of int: Edges = 1..E;

array[Edges] of int: tail = [1, 1, 2, 2, 3];
array[Edges] of int: head = [2, 3, 3, 4, 4];

array[Edges] of int: cap  = [8, 7, 2, 4, 12];

int: s = 1;
int: t = 4;

% Variables
%-----------------------------
% Flow on each edge (0..max capacity)
array[Edges] of var 0..max(cap): f;

% Total flow value (bounded by total outgoing capacity of the source)
var 0..(sum(e in Edges where tail[e] = s)(cap[e])): F;

% Constraints
%-----------------------------

% Edge capacity feasibility
constraint forall(e in Edges)(f[e] <= cap[e]);

% Define total flow value as total outflow from the source
constraint F = sum(e in Edges where tail[e] = s)(f[e]);

% Flow conservation at intermediate nodes (exclude source and sink)
constraint
  forall(v in Nodes where v != s /\ v != t)(
    sum(e in Edges where head[e] = v)(f[e]) =
    sum(e in Edges where tail[e] = v)(f[e])
  );

% Objective
%-----------------------------
solve maximize F;