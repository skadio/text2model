% Parameters
% Number of cities
int: n = 4;

% City index set
set of int: CITIES = 1..n;

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
% City mapping: 1=A, 2=B, 3=C, 4=D
array[CITIES, CITIES] of int: cost =
  [|  0, 19, 45, 30
   | 19,  0, 89, 46
   | 45, 89,  0, 11
   | 30, 46, 11,  0 |];

% A safe upper bound on the tour cost (sum of maximum outgoing edges from each city)
int: max_out = max([max([cost[i,j] | j in CITIES where j != i]) | i in CITIES]);
int: upper_bound_total_cost = n * max_out;

% Variables
% succ[i] is the next city visited after city i (a Hamiltonian cycle)
array[CITIES] of var CITIES: succ;

% Total travel cost of the tour
var 0..upper_bound_total_cost: total_cost;

% Constraints
% Ensure a valid Hamiltonian cycle: each city has exactly one successor and one predecessor
constraint circuit(succ);

% Forbid self-loops explicitly (defensive; circuit already enforces this)
constraint forall(i in CITIES) (succ[i] != i);

% Compute total tour cost from successor arcs
constraint total_cost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize total_cost;