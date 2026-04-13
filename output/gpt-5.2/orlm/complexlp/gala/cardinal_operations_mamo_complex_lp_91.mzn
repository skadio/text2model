include "globals.mzn";

% Cities: 1=A, 2=B, 3=C, 4=D, 5=E
int: n = 5;
set of int: Cities = 1..n;

% Travel cost matrix (symmetric, 0 on diagonal)
array[Cities, Cities] of int: cost =
  [|  0, 95, 36, 93, 16
   | 95,  0, 95, 29, 96
   | 36, 95,  0, 72, 38
   | 93, 29, 72,  0, 77
   | 16, 96, 38, 77,  0 |];

% tour[pos] = city visited at position pos (a Hamiltonian cycle up to rotation)
array[1..n] of var Cities: tour;
constraint all_different(tour);

% Break rotational symmetry by fixing the first city to A
constraint tour[1] = 1;

% Total tour cost including return to start
var 0..100000: total_cost;
constraint total_cost =
  sum(pos in 1..n-1)( cost[tour[pos], tour[pos+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

function string: cityName(int: c) =
  if c = 1 then "A"
  elseif c = 2 then "B"
  elseif c = 3 then "C"
  elseif c = 4 then "D"
  else "E" endif;

output [
  "Tour (cities) = [",
  concat([ if i > 1 then ", " else "" endif ++ cityName(fix(tour[i])) | i in 1..n ]),
  "]\n",
  "Return edge: ", cityName(fix(tour[n])), " -> ", cityName(fix(tour[1])), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];