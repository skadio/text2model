% Parameters
int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals;
set of int: L = 1..NumPorts;

array[K, L] of int: Cost;
array[L] of int: Demand;
array[K] of int: Supply;

% Variables
array[K, L] of var int: Ship;

% Constraints
constraint forall(k in K, l in L) (Ship[k,l] >= 0);

constraint forall(k in K) (
  sum(l in L)(Ship[k,l]) <= Supply[k]
);

constraint forall(l in L) (
  sum(k in K)(Ship[k,l]) == Demand[l]
);

% Objective
solve minimize sum(k in K, l in L)(Cost[k,l] * Ship[k,l]);