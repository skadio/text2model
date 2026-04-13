include "globals.mzn";

int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;

constraint StartCity in Cities;

array[Cities] of var Cities: succ;

constraint circuit(succ);
constraint forall(i in Cities)(succ[i] != i);

var int: totalDistance = sum(i in Cities)(Distances[i, succ[i]]);

solve minimize totalDistance;

output [
  "totalDistance=", show(totalDistance), "\n",
  "succ=", show(succ), "\n"
];