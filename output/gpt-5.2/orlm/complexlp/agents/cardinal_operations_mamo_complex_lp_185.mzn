% Parameters
% Node indexing: 1=S, 2..7 are nodes 2..7, 8=T
int: nNodes = 8;
set of int: N = 1..nNodes;

int: S = 1;
int: T = 8;

% Directed edge set (we include both directions where the description gives connections both ways)
int: nEdges = 18;
set of int: E = 1..nEdges;

array[E] of int: from = [
  1, 1,        % S->2, S->3
  2, 2, 2,     % 2->S, 2->4, 2->3
  3, 3, 3, 3,  % 3->S, 3->2, 3->5, 3->6
  4, 4,        % 4->2, 4->6
  5, 5,        % 5->3, 5->T
  6, 6, 6,     % 6->3, 6->4, 6->7
  7, 7,        % 7->6, 7->T
  8, 8         % T->5, T->7
];

array[E] of int: to = [
  2, 3,
  1, 4, 3,
  1, 2, 5, 6,
  2, 6,
  3, 8,
  3, 4, 7,
  6, 8,
  5, 7
];

array[E] of int: w = [
  5, 4,
  5, 3, 2,
  4, 2, 1, 7,
  3, 2,
  1, 5,
  7, 2, 3,
  3, 1,
  5, 1
];

% A safe upper bound on any shortest path length (sum of all weights)
int: UB = sum(e in E)(w[e]);


% Variables
% x[e] = 1 if directed edge e is used in the chosen S->T path
array[E] of var 0..1: x;

% Total distance of the chosen path (to be minimized)
var 0..UB: dist;

% Potential variables for subtour elimination / connectivity
array[N] of var 0..UB: pi;


% Constraints
% Compute total distance from selected edges
constraint dist = sum(e in E)(w[e] * x[e]);

% Flow conservation: ensure selected edges form a single S->T directed path

% Source node S: exactly one outgoing edge chosen, and no incoming edge chosen
constraint
  sum(e in E where from[e] = S)(x[e]) = 1 /\
  sum(e in E where to[e] = S)(x[e]) = 0;

% Target node T: exactly one incoming edge chosen, and no outgoing edge chosen
constraint
  sum(e in E where to[e] = T)(x[e]) = 1 /\
  sum(e in E where from[e] = T)(x[e]) = 0;

% Intermediate nodes: flow in equals flow out (either 0 if unused, or 1 if on the path)
constraint
  forall(v in N where v != S /\ v != T) (
    sum(e in E where to[e] = v)(x[e]) = sum(e in E where from[e] = v)(x[e])
  );

% Intermediate nodes: at most one outgoing edge (prevents branching)
constraint
  forall(v in N where v != S /\ v != T) (
    sum(e in E where from[e] = v)(x[e]) <= 1
  );

% Subtour elimination / connectivity via potentials
% Fix potential at source
constraint pi[S] = 0;

% If edge e is used, enforce pi[to] >= pi[from] + w[e]; relaxed when x[e]=0 via big-M
constraint
  forall(e in E) (
    pi[to[e]] >= pi[from[e]] + w[e] - UB * (1 - x[e])
  );


% Objective
solve minimize dist;