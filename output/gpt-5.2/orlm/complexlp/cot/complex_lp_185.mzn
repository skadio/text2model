% Parameters (with values embedded)
int: N = 8; % nodes: 1=S, 2..7, 8=T
int: S = 1;
int: T = 8;

set of int: V = 1..N;

% Undirected edges listed once (u < v) with weights
int: M = 10;
array[1..M] of int: U = [1, 1, 2, 2, 3, 3, 4, 5, 6, 7];
array[1..M] of int: Vv = [2, 3, 3, 4, 5, 6, 6, 8, 7, 8];
array[1..M] of int: W = [5, 4, 2, 3, 1, 7, 2, 5, 3, 1];

int: BIGM = 1000;

% Variables
array[1..M] of var 0..1: use;             % whether edge e is used in the path
array[V] of var 0..BIGM: dist;            % shortest distance labels
array[V] of var bool: reach;              % whether node is on the chosen path

% Constraints
constraint reach[S] = true;
constraint reach[T] = true;

% Degree constraints for a simple S-T path:
% - S has exactly 1 incident used edge
% - T has exactly 1 incident used edge
% - other nodes have degree 0 or 2 (enforced by reach variable)
constraint
  sum(e in 1..M where U[e] = S \/ Vv[e] = S)(use[e]) = 1;
constraint
  sum(e in 1..M where U[e] = T \/ Vv[e] = T)(use[e]) = 1;

constraint
  forall(i in V where i != S /\ i != T) (
    sum(e in 1..M where U[e] = i \/ Vv[e] = i)(use[e]) = 2 * bool2int(reach[i])
  );

% Link reach with incident edges (if any used edge touches i, then reach[i]=true)
constraint
  forall(i in V where i != S /\ i != T)(
    sum(e in 1..M where U[e] = i \/ Vv[e] = i)(use[e]) <= 2 * bool2int(reach[i])
  );

% Distance consistency to eliminate disconnected cycles:
constraint dist[S] = 0;

% If an edge is used, it must connect nodes whose dist differs by its weight
constraint
  forall(e in 1..M) (
    use[e] = 1 ->
      ( dist[U[e]] + W[e] = dist[Vv[e]] \/ dist[Vv[e]] + W[e] = dist[U[e]] )
  );

% Ensure used edges only connect reached nodes
constraint
  forall(e in 1..M) (
    use[e] = 1 -> (reach[U[e]] /\ reach[Vv[e]])
  );

% Objective
solve minimize dist[T];

output [
  "Shortest distance S->T (meters, rounded): ", show(dist[T]), "\n"
];