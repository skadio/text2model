include "globals.mzn";

% Traveling Salesperson Problem for 5 locations: E,F,G,H,I
int: n = 5;
set of int: LOC = 1..n;

% Index mapping: 1=E, 2=F, 3=G, 4=H, 5=I
array[LOC, LOC] of int: cost =
 [|  0, 65, 10, 25, 82
  | 65,  0, 98, 42, 26
  | 10, 98,  0, 75, 72
  | 25, 42, 75,  0, 46
  | 82, 26, 72, 46,  0 |];

% tour[pos] = location visited at position pos (a Hamiltonian cycle, up to rotation)
array[LOC] of var LOC: tour;

% Break rotational symmetry by fixing the start location to E (1)
constraint tour[1] = 1;

% Visit each location exactly once
constraint all_different(tour);

% Total cost (including return to start)
var int: totalCost =
  sum(p in 1..n-1)( cost[tour[p], tour[p+1]] ) + cost[tour[n], tour[1]];

solve minimize totalCost;

output [
  "Tour (1=E,2=F,3=G,4=H,5=I) = ", show(tour), "\n",
  "Minimum total delivery cost = ", show(totalCost), "\n"
];