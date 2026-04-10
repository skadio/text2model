% Parameters
int: n = 4;                               % number of locations
set of int: LOCS = 1..n;                  % location indices (1=E, 2=F, 3=G, 4=H)

array[LOCS, LOCS] of int: cost =          % delivery cost from i to j
[
  %    E   F   G   H
  |   0, 62, 51, 50  % E
  |  62,  0, 42, 69  % F
  |  51, 42,  0, 11  % G
  |  50, 69, 11,  0  % H
];

% Variables
array[LOCS, LOCS] of var 0..1: x;         % x[i,j]=1 if the route goes directly from i to j
array[LOCS] of var LOCS: succ;            % successor of location i in the tour
var 0..sum(i in LOCS, j in LOCS)(cost[i,j]): total_cost;  % total tour cost (safe upper bound)

% Constraints

% Link binary arc variables x with successor representation succ
constraint
  forall(i in LOCS, j in LOCS) (
    x[i,j] = bool2int(succ[i] = j)
  );

% Disallow self-loops (no location can go directly to itself)
constraint
  forall(i in LOCS) (
    x[i,i] = 0
  );

% Exactly one outgoing arc from each location
constraint
  forall(i in LOCS) (
    sum(j in LOCS)(x[i,j]) = 1
  );

% Exactly one incoming arc to each location
constraint
  forall(j in LOCS) (
    sum(i in LOCS)(x[i,j]) = 1
  );

% Enforce a single Hamiltonian cycle visiting all locations exactly once
constraint
  circuit(succ);

% Define total delivery cost of the tour from selected arcs
constraint
  total_cost = sum(i in LOCS, j in LOCS)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;