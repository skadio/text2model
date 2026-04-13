% Parameters
% Number of cities
int: n = 4;

% City indices (1..n correspond to E,F,G,H)
set of int: CITIES = 1..n;

% Travel cost matrix cost[i,j] (cost from city i to city j)
array[CITIES, CITIES] of int: cost =
  [|  0, 17, 52, 79  % E -> (E,F,G,H)
   | 17,  0, 15, 71  % F -> (E,F,G,H)
   | 52, 15,  0, 54  % G -> (E,F,G,H)
   | 79, 71, 54,  0  % H -> (E,F,G,H)
  |];

% Upper bound on any tour cost (safe simple bound)
int: maxArc = max([cost[i,j] | i in CITIES, j in CITIES]);
int: maxTourCost = n * maxArc;

% Variables
% next[i] = city visited immediately after city i in the tour
array[CITIES] of var CITIES: next;

% Total travel cost of the Hamiltonian cycle
var 0..maxTourCost: total_cost;

% Constraints
include "globals.mzn";

% --- No self-loops ---
constraint
  forall(i in CITIES) (
    next[i] != i
  );

% --- Single Hamiltonian cycle (visit each city exactly once and return) ---
constraint
  circuit(next);

% --- Total travel cost equals sum of chosen arcs in the cycle ---
constraint
  total_cost = sum(i in CITIES) (
    cost[i, next[i]]
  );

% Objective
solve minimize total_cost;