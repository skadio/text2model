% Parameters

% Number of locations
int: n = 6;

% Index set of locations (1..n correspond to A..F)
set of int: LOCS = 1..n;

% Delivery cost matrix: cost[i,j] is the cost to go from location i to location j
% Locations: 1=A, 2=B, 3=C, 4=D, 5=E, 6=F
array[LOCS, LOCS] of int: cost =
[
  %   A   B   C   D   E   F
  [  0, 77, 89, 19, 31, 62], % A
  [ 77,  0, 36, 81, 71, 93], % B
  [ 89, 36,  0, 32, 48, 36], % C
  [ 19, 81, 32,  0, 98, 82], % D
  [ 31, 71, 48, 98,  0, 66], % E
  [ 62, 93, 36, 82, 66,  0]  % F
];

% Upper bound for total tour cost (safe bound: n * max arc cost)
int: max_arc_cost = max([cost[i,j] | i in LOCS, j in LOCS]);
int: max_total_cost = n * max_arc_cost;


% Variables

% succ[i] = the next location visited after i (Hamiltonian cycle representation)
array[LOCS] of var LOCS: succ;

% Total delivery cost of the tour
var 0..max_total_cost: total_cost;


% Constraints

% --- Hamiltonian cycle structure (each node has exactly one successor and one predecessor) ---
% all_different ensures each location has a unique outgoing arc (successor)
% circuit enforces a single tour visiting all locations exactly once and returning to start
constraint all_different(succ);
constraint circuit(succ);

% --- Total cost computation for the chosen tour ---
% Accumulate the travel cost for each selected arc i -> succ[i]
constraint
  total_cost = sum(i in LOCS)(cost[i, succ[i]]);


% Objective

solve minimize total_cost;