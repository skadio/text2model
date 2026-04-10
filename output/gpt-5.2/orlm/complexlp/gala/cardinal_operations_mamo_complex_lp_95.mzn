include "globals.mzn";

/* Locations: 1=E, 2=F, 3=G, 4=H */
int: n = 4;
set of int: LOC = 1..n;

/* Cost matrix (0 on diagonal, symmetric as given) */
array[LOC, LOC] of int: cost =
  [|  0, 62, 51, 50
   | 62,  0, 42, 69
   | 51, 42,  0, 11
   | 50, 69, 11,  0 |];

/* tour[pos] = location visited at position pos */
array[1..n] of var LOC: tour;
constraint all_different(tour);

/* Break rotational symmetry: fix start at E (1) */
constraint tour[1] = 1;

/* Total tour cost including return to start */
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

function string: locName(int: l) =
  if l = 1 then "E"
  elseif l = 2 then "F"
  elseif l = 3 then "G"
  else "H" endif;

output [
  "Tour (by locations) = [",
  concat([ if i>1 then ", " else "" endif ++ locName(tour[i]) | i in 1..n ]),
  "]\n",
  "Return to start = ", locName(tour[1]), "\n",
  "Minimum total delivery cost = ", show(total_cost), "\n"
];