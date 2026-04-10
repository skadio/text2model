include "globals.mzn";

int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

set of int: CITIES = 1..N;

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;
array[CITIES] of var 0..N-1: pos;

var int: total_distance;

constraint StartCity >= 1 /\ StartCity <= N;

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint circuit(succ);
constraint inverse(succ, pred);

constraint pos[StartCity] = 0;
constraint forall(i in CITIES where i != StartCity)(pos[i] >= 1);

constraint forall(i in CITIES, j in CITIES where i != j /\ i != StartCity /\ j != StartCity)(
  pos[i] + 1 <= pos[j] + (N-1) * (1 - bool2int(succ[i] == j))
);

constraint total_distance = sum(i in CITIES)(Distances[i, succ[i]]);

solve minimize total_distance;