int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

set of int: Cities = 1..N;
set of int: Positions = 1..N;

array[Positions] of var Cities: route;
var int: totalDistance;

constraint StartCity in Cities;
constraint route[1] = StartCity;
constraint alldifferent(route);

constraint
    totalDistance =
        sum(k in 1..N-1)(Distances[route[k], route[k+1]]) +
        Distances[route[N], route[1]];

solve minimize totalDistance;