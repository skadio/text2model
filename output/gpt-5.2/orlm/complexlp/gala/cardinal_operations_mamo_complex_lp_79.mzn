include "globals.mzn";

% Traveling Salesperson Problem (5 cities)
int: n = 5;
set of int: Cities = 1..n;

% City indices: 1=A, 2=B, 3=C, 4=D, 5=E
array[Cities, Cities] of int: cost =
  [|  0, 44, 19, 92, 71
   | 44,  0, 22, 84, 63
   | 19, 22,  0, 47, 89
   | 92, 84, 47,  0, 78
   | 71, 63, 89, 78,  0 |];

% tour[pos] is the city visited at position pos in the cycle
array[Cities] of var Cities: tour;
constraint all_different(tour);

% Total cost of the Hamiltonian cycle (including return to start)
var int: total_cost =
  sum(p in 1..n-1)( cost[tour[p], tour[p+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

function string: cityName(int: c) =
  if c=1 then "A"
  elseif c=2 then "B"
  elseif c=3 then "C"
  elseif c=4 then "D"
  else "E" endif;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Tour (cycle order) = ", show([cityName(fix(tour[i])) | i in Cities]), "\n",
  "Return to start = ", cityName(fix(tour[1])), "\n"
];