% Parameters
int: N;
int: StartCity;                       % 0-based index of the departure city
array[1..N, 1..N] of int: Distances;  % symmetric distance matrix

% Derived sets & constants
set of int: Cities = 1..N;
int: StartCity1 = StartCity + 1;      % 1-based counterpart (1-based index)
int: maxTotalDistance = sum(i in Cities, j in Cities)(Distances[i, j]);

% Variables
array[1..N] of var Cities: tour;      % visit sequence (first position is the start city)
var 0..maxTotalDistance: TotalDistance;

% Constraints
constraint tour[1] = StartCity1;
constraint all_different(tour);

% Symmetry-breaking
constraint tour[2] < tour[N];

constraint
    TotalDistance =
        sum(k in 1..N-1)(Distances[tour[k], tour[k+1]])
      + Distances[tour[N], tour[1]];

% Objective
solve minimize TotalDistance;