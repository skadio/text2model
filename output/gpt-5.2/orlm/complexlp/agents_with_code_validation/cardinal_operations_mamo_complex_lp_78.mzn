% Parameters
int: n = 6;                                % Number of locations
set of int: LOC = 1..n;                    % Location indices (1=A, 2=B, 3=C, 4=D, 5=E, 6=F)

array[LOC, LOC] of int: cost =             % Delivery cost matrix (cost[i,i] = 0)
  [|  0, 77, 89, 19, 31, 62
   | 77,  0, 36, 81, 71, 93
   | 89, 36,  0, 32, 48, 36
   | 19, 81, 32,  0, 98, 82
   | 31, 71, 48, 98,  0, 66
   | 62, 93, 36, 82, 66,  0 |];

int: start = 1;                            % Fix a start to break symmetry (any tour can be rotated)
set of int: POS = 1..n;                    % Positions in the tour

int: max_cost = max([cost[i,j] | i in LOC, j in LOC]);  % Upper bound component for objective
int: ub_total_cost = n * max_cost;         % Simple upper bound for total tour cost

% Variables
array[POS] of var LOC: tour;               % tour[p] = location visited at position p
var 0..ub_total_cost: total_cost;          % Total cost of completing the cycle

% Constraints
include "alldifferent.mzn";

% Visit each location exactly once (Hamiltonian tour)
constraint
  all_different(tour);

% Symmetry breaking: fix the first position to the chosen start location
constraint
  tour[1] = start;

% Compute total cycle cost: sum of consecutive legs + return to start
constraint
  total_cost =
    sum(p in 1..n-1)( cost[tour[p], tour[p+1]] )
    + cost[tour[n], tour[1]];

% Objective
solve minimize total_cost;