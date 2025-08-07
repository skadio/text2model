% Parameters
int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

% Variables
array[1..N] of var 1..N: tour;
var int: totalDist;

% Derived
int: startIdx = StartCity + 1;

% Constraints
constraint tour[1] = startIdx;
constraint all_different(tour);
constraint totalDist = sum(i in 1..N-1)(Distances[tour[i], tour[i+1]]) + Distances[tour[N], startIdx];

% Objective
solve minimize totalDist;

% Output
output ["Tour: ", show(tour), "\n", "Total distance: ", show(totalDist), "\n"];