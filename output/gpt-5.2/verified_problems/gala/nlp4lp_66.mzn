include "globals.mzn";

int: N;                         % number of cities
int: StartCity;                 % index of start city (0-based in data)
array[1..N, 1..N] of int: Distances;  % symmetric, Distances[i,j] in miles

% Convert start city to 1-based index for MiniZinc
int: s = StartCity + 1;

% tour[1..N] is a permutation of cities (1..N), with tour[1] fixed to start city
array[1..N] of var 1..N: tour;
constraint all_different(tour);
constraint tour[1] = s;

% Total length of the cycle (including return from last to first)
var int: total_distance =
  sum(i in 1..N-1)( Distances[tour[i], tour[i+1]] ) + Distances[tour[N], tour[1]];

solve minimize total_distance;

output [
  "StartCity(0-based) = ", show(StartCity), "\n",
  "Tour(1-based) = ", show(tour), "\n",
  "Tour(0-based) = ", show([tour[i]-1 | i in 1..N]), "\n",
  "TotalDistance = ", show(total_distance), "\n"
];