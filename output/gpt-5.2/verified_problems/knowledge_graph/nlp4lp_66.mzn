include "globals.mzn";

int: N;
int: StartCity; % expected 0..N-1

array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;

function int: toInternal(int: c) = c + 1;

int: start = toInternal(StartCity);

array[1..N] of var Cities: Route;

constraint Route[1] = start;
constraint all_different(Route);

var int: TotalDistance =
  sum(i in 1..N-1)(Distances[Route[i], Route[i+1]])
  + Distances[Route[N], Route[1]];

solve minimize TotalDistance;

output [
  "TotalDistance = ", show(TotalDistance), "\n",
  "Route(1-based) = ", show(Route), "\n",
  "Route(0-based) = ", show([Route[i]-1 | i in 1..N]), "\n"
];