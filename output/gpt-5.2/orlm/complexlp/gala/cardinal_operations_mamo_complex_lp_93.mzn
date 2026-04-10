include "globals.mzn";

% Cities: 1=A, 2=B, 3=C, 4=D
int: n = 4;

array[1..n, 1..n] of int: cost =
  [|  0, 61, 65, 63
   | 61,  0, 94, 31
   | 65, 94,  0, 19
   | 63, 31, 19,  0 |];

% tour[pos] = city visited at position pos (a permutation)
array[1..n] of var 1..n: tour;
constraint all_different(tour);

% Total cost of the Hamiltonian cycle: tour[1] -> ... -> tour[n] -> tour[1]
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

% Symmetry breaking: fix start city to A (doesn't change optimal cost for a cycle)
constraint tour[1] = 1;

solve minimize total_cost;

output [
  "Tour (1=A,2=B,3=C,4=D) = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];