% Parameters
int: n = 6;                                   % number of locations
set of int: LOC = 1..n;                       % location indices

array[LOC, LOC] of int: cost =                % delivery cost matrix
  [|  0, 48, 23, 70, 14, 20
   | 48,  0, 79, 37, 63, 96
   | 23, 79,  0, 40, 66, 68
   | 70, 37, 40,  0, 70, 28
   | 14, 63, 66, 70,  0, 73
   | 20, 96, 68, 28, 73,  0 |];

int: cost_ub = sum(i in LOC, j in LOC)(cost[i,j]);  % simple upper bound for objective

% Variables
array[LOC] of var LOC: succ;                  % successor location in the tour for each location
var 0..cost_ub: total_cost;                   % total tour cost (bounded)

% Constraints

% Ensure succ forms a single Hamiltonian cycle visiting each location exactly once
constraint
  circuit(succ);

% Compute total tour cost as sum of costs along successor arcs
constraint
  total_cost = sum(i in LOC)( cost[i, succ[i]] );

% (Redundant but clarifying) Disallow self-loops explicitly (already implied by circuit)
constraint
  forall(i in LOC)(
    succ[i] != i
  );

% Objective
solve minimize total_cost;