include "globals.mzn";

% Cities: 1=E, 2=F, 3=G, 4=H, 5=I
int: n = 5;
set of int: CITIES = 1..n;

% Cost matrix (symmetric, 0 on diagonal)
array[CITIES, CITIES] of int: cost =
[|  0, 50, 48, 99, 91
 | 50,  0, 57, 84, 72
 | 48, 57,  0, 46, 86
 | 99, 84, 46,  0, 29
 | 91, 72, 86, 29,  0 |];

% tour[pos] is the city visited at position pos in the cycle
array[1..n] of var CITIES: tour;

% Break rotational symmetry: fix start city to E (1)
constraint tour[1] = 1;

% Visit each city exactly once
constraint all_different(tour);

% Total cycle cost (including return to start)
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

function string: city_name(int: c) =
  if c = 1 then "E"
  elseif c = 2 then "F"
  elseif c = 3 then "G"
  elseif c = 4 then "H"
  else "I" endif;

output [
  "Least total delivery cost = ", show(total_cost), "\n",
  "Tour (cycle) = ",
  concat([ city_name(fix(tour[i])) ++ (if i < n then " -> " else "" endif) | i in 1..n ]),
  " -> ", city_name(fix(tour[1])), "\n"
];