include "globals.mzn";

int: N;
int: StartCity;
array[1..N, 1..N] of int: Distances;

% Convert 0‑based StartCity to 1‑based index for the model
int: startIndex = StartCity + 1;

% Order in which the cities are visited
array[1..N] of var 1..N: tour;

% All cities must appear exactly once, and the first city is fixed
constraint all_different(tour);
constraint tour[1] = startIndex;

% Total distance of the tour (returning to the start city)
var int: totalDist;
constraint
    totalDist = sum(i in 1..N) (
        Distances[
            tour[i],
            tour[ if i < N then i+1 else 1 ]
        ]
    );

solve minimize totalDist;

output [
    "Tour = ", show(tour), "\n",
    "Total distance = ", show(totalDist), "\n"
];