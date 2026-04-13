% Traveling Salesperson Problem (6 locations A..F) with embedded data

include "alldifferent.mzn";

int: n = 6;
set of int: N = 1..n;

array[N] of string: name = ["A","B","C","D","E","F"];

% Cost matrix (symmetric), with 0 on diagonal
array[N,N] of int: cost =
[
 %  A   B   C   D   E   F
   [ 0, 77, 89, 19, 31, 62], % A
   [77,  0, 36, 81, 71, 93], % B
   [89, 36,  0, 32, 48, 36], % C
   [19, 81, 32,  0, 98, 82], % D
   [31, 71, 48, 98,  0, 66], % E
   [62, 93, 36, 82, 66,  0]  % F
];

% Fix the starting point to A to remove rotational symmetry (cycle cost is invariant)
int: start = 1;

% Tour as an order of visiting nodes, starting at A
array[N] of var N: tour;
constraint tour[1] = start;
constraint all_different(tour);

% Total cost of the Hamiltonian cycle
var int: total_cost =
  sum(i in 1..n-1)(cost[tour[i], tour[i+1]]) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Route: ",
  concat([ if i=1 then name[fix(tour[i])]
           else " -> " ++ name[fix(tour[i])]
         endif
         | i in N ]),
  " -> ", name[fix(tour[1])], "\n"
];