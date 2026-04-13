include "globals.mzn";

% ----- Data (embedded) -----
int: n = 4;
array[1..n, 1..n] of int: dist =
  [| 0, 10, 20, 12
   | 10, 0,  5, 10
   | 20, 5,  0,  8
   | 15,12,  8,  0 |];

% ----- Decision variables -----
% tour[pos] = city visited at position pos
array[1..n] of var 1..n: tour;

% ----- Constraints -----
constraint all_different(tour);

% Fix starting city to remove rotational symmetry (start at city 1)
constraint tour[1] = 1;

% Optional: break reverse symmetry (choose one direction among mirror tours)
constraint tour[2] < tour[n];

% Total distance of the cycle (including return to start)
var int: totalDist =
  sum(i in 1..n-1)( dist[tour[i], tour[i+1]] )
  + dist[tour[n], tour[1]];

% ----- Solve -----
solve minimize totalDist;

% ----- Output -----
output [
  "Tour (cities in order) = ", show(tour), "\n",
  "Return to start: 1\n",
  "Total distance = ", show(totalDist), "\n"
];