include "globals.mzn";

int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;
int: Start = StartCity + 1;

array[Cities] of var Cities: succ;
array[Cities] of var Cities: pred;
var int: totalDistance;

constraint circuit(succ);
constraint inverse(succ, pred);

constraint totalDistance = sum(i in Cities)(Distances[i, succ[i]]);

solve minimize totalDistance;