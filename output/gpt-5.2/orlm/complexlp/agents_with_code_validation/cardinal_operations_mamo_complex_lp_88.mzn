include "globals.mzn";

% Parameters
int: n = 5;                          % number of locations
set of int: LOC = 1..n;              % locations indexed 1..5 (E=1,F=2,G=3,H=4,I=5)

array[LOC, LOC] of int: cost = array2d(LOC, LOC, [
   0, 65, 10, 25, 82,   % from E
  65,  0, 98, 42, 26,   % from F
  10, 98,  0, 75, 72,   % from G
  25, 42, 75,  0, 46,   % from H
  82, 26, 72, 46,  0    % from I
]);

int: maxCost = max([cost[i,j] | i in LOC, j in LOC]);

% Variables
array[LOC] of var LOC: succ;           % successor location for each location (defines the tour)
var 0..(n * maxCost): totalCost;       % total tour cost (bounded)

% Constraints
constraint circuit(succ);              % permutation + single Hamiltonian cycle + no self-loops

constraint totalCost = sum(i in LOC)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output ["totalCost = \(totalCost)\n",
        "succ = \(succ)\n"];